package main

import (
	"runtime"

	"github.com/shirou/gopsutil/v4/cpu"
	"github.com/shirou/gopsutil/v4/mem"
)

var mS runtime.MemStats

// GetMetric() - get runtime Metrics
func GetRuntimeMetric() map[string]float64 {

	v, _ := mem.VirtualMemory()
	cc, _ := cpu.Counts(true)

	runtime.ReadMemStats(&mS)

	gaugeMap := map[string]float64{

		"TotalMemory":     float64(v.Total),
		"FreeMemory":      float64(v.Free),
		"CPUutilization1": float64(cc),

		"Alloc":         float64(mS.Alloc),
		"BuckHashSys":   float64(mS.BuckHashSys),
		"Frees":         float64(mS.Frees),
		"GCCPUFraction": float64(mS.GCCPUFraction),
		"GCSys":         float64(mS.GCSys),
		"HeapAlloc":     float64(mS.HeapAlloc),
		"HeapIdle":      float64(mS.HeapIdle),
		"HeapInuse":     float64(mS.HeapInuse),
		"HeapObjects":   float64(mS.HeapObjects),
		"HeapReleased":  float64(mS.HeapReleased),
		"HeapSys":       float64(mS.HeapSys),
		"LastGC":        float64(mS.LastGC),
		"Lookups":       float64(mS.Lookups),
		"MCacheInuse":   float64(mS.MCacheInuse),
		"MCacheSys":     float64(mS.MCacheSys),
		"MSpanInuse":    float64(mS.MSpanInuse),
		"MSpanSys":      float64(mS.MSpanSys),
		"Mallocs":       float64(mS.Mallocs),
		"NextGC":        float64(mS.NextGC),
		"NumForcedGC":   float64(mS.NumForcedGC),
		"NumGC":         float64(mS.NumGC),
		"OtherSys":      float64(mS.OtherSys),
		"PauseTotalNs":  float64(mS.PauseTotalNs),
		"StackInuse":    float64(mS.StackInuse),
		"StackSys":      float64(mS.StackSys),
		"Sys":           float64(mS.Sys),
		"TotalAlloc":    float64(mS.TotalAlloc),
		"PollCount":     0, // self-defined
	}
	return gaugeMap
}
