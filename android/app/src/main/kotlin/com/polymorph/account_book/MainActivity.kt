package com.polymorph.account_book

import android.annotation.SuppressLint
import android.net.Uri
import android.text.format.DateFormat
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.sql.Date

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.polymorph.account_book/read_sms"
    var uriSms = Uri.parse("content://sms/inbox")

    @SuppressLint("Recycle")
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "getValue") {
                var smsList = mutableListOf<Map<String, String>>()

                val cursor = contentResolver.query(
                    uriSms,
                    arrayOf("_id", "address", "date", "body"),
                    null,
                    null,
                    null
                )
                cursor?.moveToFirst()

                var flag = true
                while (flag) {
                    val address = cursor!!.getString(1)
                    val day = cursor!!.getLong(2)
                    val body = cursor!!.getString(3)

                    // 삼성카드
                    if (address.equals("15888900")) {
                        val regText = Regex("(?<=:[0-9]{2}[ ,\n]).+")
                        val regPrice = Regex("[0-9,-]+(,?[0-9]+)+원")
                        val regTime = Regex("[0-9]{2}:[0-9]{2}")
                        val regDate = Regex("[0-9]{2}/[0-9]{2}")

                        val time = regTime.find(body) // 시간
                        val date = regDate.find(body) // 날짜
                        val timeDate = date!!.value + " " + time!!.value // 날짜 + 시간
                        val timestamp =
                            DateFormat.format("yyyyMMddhhmm", Date(day)).toString() // 문자받은 시간
                        val price = regPrice.find(body) // 금액
                        val text = regText.find(body) // 거래내용
                        var vText = text?.value?.replace("(금액)", "") // 거래내용 파싱

                        var list: List<String>
                        if (vText != null) {
                            list = vText.split(" ")

                            vText =
                                if (list[0] == price?.value) list[1]
                                else list[0]
                        }

                        smsList.add(
                            mapOf(
                                Pair("address", address.toString()),
                                Pair("date", timeDate),
                                Pair("timestamp", timestamp),
                                Pair("text", vText.toString()),
                                Pair("price", price!!.value)
                            )
                        )
                    }

                    if (cursor.isLast)
                        flag = false
                    cursor.moveToNext()
                }
                result.success(smsList)
            }
        }
    }
}
