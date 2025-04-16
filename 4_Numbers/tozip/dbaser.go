//  разбирается код тестового приложения, использующего YDB Go SDK https://ydb.tech/docs/ru/dev/example-app/go/
//  ydb-go-sdk - pure Go native and database/sql driver for YDB https://pkg.go.dev/github.com/ydb-platform/ydb-go-sdk/v3@v3.99.13

package main

import (
	"context"
	"errors"
	"fmt"
	"os"

	"github.com/ydb-platform/ydb-go-sdk/v3"
	"github.com/ydb-platform/ydb-go-sdk/v3/query"
)

// ConnectToBase подключение к базе данных
func ConnectToBase(ctx context.Context) (db *ydb.Driver, err error) {
	tok, err := GetToken(ctx)
	if err != nil {
		return nil, fmt.Errorf("get token %w", err)
	}
	dsn := os.Getenv("DATABASE_DSN")
	if dsn == "" {
		return nil, errors.New("не задана переменная окружения с эндпоинтом Базы Данных")
	}
	db, err = ydb.Open(ctx, dsn, ydb.WithAccessTokenCredentials(tok.Token))

	if err != nil {
		return nil, err
	}
	return
}

// getBaseMetrics чтение метрик из Базы данных и возврат в массиве
func getBaseMetrics(ctx context.Context, db *ydb.Driver) (metras []metroBase, err error) {

	readTx := query.TxControl(
		query.BeginTx(
			query.WithSnapshotReadOnly(),
		),
		query.CommitTx(),
	)
	rows, err := db.Query().QueryResultSet(ctx, "SELECT metricname, value, updated_at FROM metrics ;", query.WithTxControl(readTx))
	if err != nil {
		return nil, err
	}
	defer rows.Close(ctx)

	for {
		row, err := rows.NextRow(ctx)
		if err != nil {
			break
		}
		metr := metroBase{}
		errScan := row.Scan(&metr.Metricname, &metr.Value, &metr.Updated_at)
		if err != nil {
			return nil, errScan
		}
		metras = append(metras, metr)
	}
	return
}

func putMetrics2Base(ctx context.Context, db *ydb.Driver, metras map[string]float64) (err error) {

	err = db.Query().DoTx(ctx, func(ctx context.Context, t query.TxActor) error {
		for metr, value := range metras {
			order := ""
			if metr == "PollCount" { // PollCount - счётчик обновлений метрик, увеличить на 1
				order = "UPDATE metrics SET value=value+1, updated_at=CurrentUtcDatetime() WHERE metricname = 'PollCount' ;"
			} else {
				order = fmt.Sprintf("UPSERT INTO metrics (metricname, value, updated_at) VALUES ('%s', %g, CurrentUtcDatetime() ) ;", metr, value)
			}
			err = t.Exec(ctx, order)

			if err != nil {
				return err
			}
		}
		return err
	})

	return nil
}
