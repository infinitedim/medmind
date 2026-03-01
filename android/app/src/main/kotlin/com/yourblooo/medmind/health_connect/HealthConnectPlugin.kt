// HealthConnectPlugin.kt
package com.yourblooo.medmind.health_connect

import android.app.Activity
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.records.SleepSessionRecord
import androidx.health.connect.client.records.StepsRecord
import androidx.health.connect.client.records.HeartRateRecord
import androidx.health.connect.client.request.ReadRecordsRequest
import androidx.health.connect.client.time.TimeRangeFilter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.time.Instant
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class HealthConnectPlugin(private val activity: Activity) : MethodCallHandler {
    private val scope = CoroutineScope(Dispatchers.Main)
    private val healthConnectClient by lazy {
        HealthConnectClient.getOrCreate(activity)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "isAvailable" -> checkAvailability(result)
            "requestPermissions" -> requestPermissions(result)
            "readSleepSessions" -> readSleepData(call, result)
            "readSteps" -> readStepData(call, result)
            "readHeartRate" -> readHeartRateData(call, result)
            else -> result.notImplemented()
        }
    }

    private fun readSleepData(call: MethodCall, result: Result) {
        val startTime = Instant.parse(call.argument<String>("startTime")!!)
        val endTime = Instant.parse(call.argument<String>("endTime")!!)

        scope.launch {
            try {
                val response = healthConnectClient.readRecords(
                    ReadRecordsRequest(
                        recordType = SleepSessionRecord::class,
                        timeRangeFilter = TimeRangeFilter.between(startTime, endTime)
                    )
                )
                val sleepData = response.records.map { record ->
                    mapOf(
                        "startTime" to record.startTime.toString(),
                        "endTime" to record.endTime.toString(),
                        "stages" to record.stages.map { stage ->
                            mapOf("type" to stage.stage, "start" to stage.startTime.toString(), "end" to stage.endTime.toString())
                        }
                    )
                }
                result.success(sleepData)
            } catch (e: Exception) {
                result.error("HEALTH_CONNECT_ERROR", e.message, null)
            }
        }
    }

    private fun checkAvailability(result: Result) {
        val status = HealthConnectClient.getSdkStatus(activity)
        result.success(status == HealthConnectClient.SDK_AVAILABLE)
    }

    private fun requestPermissions(result: Result) {
        result.error("NOT_SUPPORTED", "Request permissions via the Flutter side", null)
    }

    private fun readStepData(call: MethodCall, result: Result) {
        val startTime = Instant.parse(call.argument<String>("startTime")!!)
        val endTime = Instant.parse(call.argument<String>("endTime")!!)
        scope.launch {
            try {
                val response = healthConnectClient.readRecords(
                    ReadRecordsRequest(
                        recordType = StepsRecord::class,
                        timeRangeFilter = TimeRangeFilter.between(startTime, endTime)
                    )
                )
                val total = response.records.sumOf { it.count }
                result.success(total)
            } catch (e: Exception) {
                result.error("HEALTH_CONNECT_ERROR", e.message, null)
            }
        }
    }

    private fun readHeartRateData(call: MethodCall, result: Result) {
        val startTime = Instant.parse(call.argument<String>("startTime")!!)
        val endTime = Instant.parse(call.argument<String>("endTime")!!)
        scope.launch {
            try {
                val response = healthConnectClient.readRecords(
                    ReadRecordsRequest(
                        recordType = HeartRateRecord::class,
                        timeRangeFilter = TimeRangeFilter.between(startTime, endTime)
                    )
                )
                val samples = response.records.flatMap { record ->
                    record.samples.map { mapOf("bpm" to it.beatsPerMinute, "time" to it.time.toString()) }
                }
                result.success(samples)
            } catch (e: Exception) {
                result.error("HEALTH_CONNECT_ERROR", e.message, null)
            }
        }
    }
}