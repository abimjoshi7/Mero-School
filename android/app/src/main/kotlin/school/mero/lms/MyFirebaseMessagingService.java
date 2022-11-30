package school.mero.lms;


import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import com.webengage.sdk.android.WebEngage;

import java.util.Map;

import android.util.Log;

public class MyFirebaseMessagingService extends FirebaseMessagingService {
    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        Map<String, String> data = remoteMessage.getData();
        if(data != null) {
            if(data.containsKey("source") && "webengage".equals(data.get("source"))) {



                Log.d("tag--", ""+ data.toString());
//                WebEngage.get().receive(data);
                if(data.toString().contains("RATING_V1") || data.toString().contains("CAROUSEL_V1")){
                     WebEngage.get().receive(data);
                }

            }
        }
    }
}