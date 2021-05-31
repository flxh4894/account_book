package com.polymorph.account_book

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import android.util.Log
import java.util.*

class SmsReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        Log.d("SmsReceiver", "onReceive() called!");

        if(context == null || intent == null || intent.action == null){
            return
        }
        if (intent.action != (Telephony.Sms.Intents.SMS_RECEIVED_ACTION)) {
            return
        }
        val contentResolver = context.contentResolver
        val smsMessages = Telephony.Sms.Intents.getMessagesFromIntent(intent)

        for (message in smsMessages) {
            Log.d("문자메세지!", "${message.messageBody}");
            var body = message.messageBody
            var date = Date(message.timestampMillis)
            var phone = message.displayOriginatingAddress

            Log.d("문자메세지!", "$date")
            Log.d("문자메세지!", "${message.displayOriginatingAddress}");
        }
    }

}