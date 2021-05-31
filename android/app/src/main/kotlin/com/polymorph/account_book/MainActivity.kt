package com.polymorph.account_book

import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.polymorph.account_book/read_sms"
    var uriSms = Uri.parse("content://sms/inbox")

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getValue") {
                val cursor = contentResolver.query(uriSms, arrayOf("_id", "address", "date", "body"), null, null, null)
                cursor?.moveToFirst();
                while (cursor!!.moveToNext()) {
                    val address = cursor!!.getString(1)
                    val body = cursor!!.getString(3)
 
                    if(address.equals("15888900")){
                        var reg = Regex("(?<=(?<=\\:).. ).+")
                        var regPrice = Regex("[\\d,\\-]+원")
                        var tt = reg.find(body)
                        var pp = regPrice.find(body)


                        if (tt != null && pp != null) {
                            Log.d("프린트", "${tt.value}")
                            Log.d("프린트", "${pp.value}")
                        }
                    }
                }
                result.success("zzzz")
            }
        }
    }
}
