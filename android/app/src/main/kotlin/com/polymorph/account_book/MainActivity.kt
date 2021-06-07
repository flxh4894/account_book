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
//    private val CHANNEL = "com.polymorph.account_book/read_sms"
//    var uriSms = Uri.parse("content://sms/inbox")
//
//    @SuppressLint("Recycle")
//    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//        MethodChannel(
//            flutterEngine.dartExecutor.binaryMessenger,
//            CHANNEL
//        ).setMethodCallHandler { call, result ->
//            if (call.method == "getValue") {
//                val smsList = mutableListOf<Map<String, String>>()
//
//                val cursor = contentResolver.query(
//                    uriSms,
//                    arrayOf("_id", "address", "date", "body"),
//                    null,
//                    null,
//                    null
//                )
//
//                if(cursor != null){
//                    cursor.moveToFirst()
//                    var flag = true
//
//                    while (flag) {
//                        val address = cursor.getString(1)
//                        val day = cursor.getLong(2)
//                        val body = cursor.getString(3)
//
//                        // 커서 다음으로 이동 && Last Index 체크
//                        if (cursor.isLast)
//                            flag = false
//                        cursor.moveToNext()
//
//                        if(body.contains("승인거절"))
//                            continue
//
//                        // 삼성카드
//                        if (address.equals("15888900")) {
//                            val regPrice = Regex("[0-9,-]+(,?[0-9]+)+원")
//                            val price = regPrice.find(body) ?: continue // 금액 null 이면 Continue
//                            val timeDate = getDate(body) ?: continue
//                            val timestamp =
//                                DateFormat.format("yyyyMMddHHmm", Date(day)).toString() // 문자받은 시간
//                            val text = getSmsText(body, price.value)
//
//                            Log.d("번호",address.toString())
//                            Log.d("날짜",timeDate)
//                            Log.d("시간",timestamp.toString())
//                            Log.d("문자",text.toString())
//                            Log.d("가격", price.value.toString())
//                            Log.d("******","**********************")
//
//                        smsList.add(
//                            mapOf(
//                                Pair("address", address.toString()),
//                                Pair("date", timeDate),
//                                Pair("date", timestamp),
//                                Pair("text", text),
//                                Pair("price", price.value)
//                            )
//                        )
//                        }
//                    }
//                }
//
//                result.success(smsList)
//            }
//        }
//    }
//
//    private fun getSmsText(body: String, price: String): String {
//
//        val regText = Regex("(?<=:[0-9]{2}[ ,\n]).+")
//        val text = regText.find(body) // 거래내용
//
//        return if(text != null) {
//            // 파싱 : (금액) 자르고 금액과 내용이 함께 붙어있는 경우 제거
//            // ex) (금액)57,000 스타벅스코리아
//            var vText = text.value.replace("(금액)", "") // 거래내용 파싱
//            val textList: List<String> = vText.split(" ")
//            vText =
//                if (textList[0] == price) textList[1]
//                else textList[0]
//
//            vText
//        } else {
//            body.replace("[Web발신]", "").replace(price,"")
//        }
//    }
//
//    // 날짜 정규식 자르기
//    private fun getDate(body: String): String? {
//        val regTime = Regex("[0-9]{2}:[0-9]{2}")
//        val regDate = Regex("[0-9]{2}/[0-9]{2}")
//
//        val time = regTime.find(body) // 시간
//        val date = regDate.find(body) // 날짜
//        if(time == null || date == null)
//            return null
//
//        return (date.value) + " " + (time.value) // 날짜 + 시간
//    }
}
