/*
 * Copyright 2017 Rúben Sousa
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package school.mero.lms.customplayer.glide;


import android.graphics.Bitmap;
import android.util.Log;

import androidx.annotation.NonNull;

import com.bumptech.glide.load.engine.bitmap_recycle.BitmapPool;
import com.bumptech.glide.load.resource.bitmap.BitmapTransformation;

import java.nio.ByteBuffer;
import java.security.MessageDigest;


public class GlideThumbnailTransformation extends BitmapTransformation {

    private static final int MAX_LINES = 10;
    private static final int MAX_COLUMNS = 30;

    private int x;
    private int y;

    public GlideThumbnailTransformation(int square) {
//        int square = (int) position / THUMBNAILS_EACH;


        x = square / MAX_COLUMNS ;
        y = square % MAX_COLUMNS ;


        Log.d("Interval....", "Square: "+square+" coordinate ("+x +","+y+")");


    }

    private int getX() {
        return x;
    }

    private int getY() {
        return y;
    }

    @Override
    protected Bitmap transform(@NonNull BitmapPool pool, @NonNull Bitmap toTransform,
                               int outWidth, int outHeight) {
        int width = toTransform.getWidth() / MAX_COLUMNS;
        int height = toTransform.getHeight() / MAX_LINES;
        return Bitmap.createBitmap(toTransform, y * width, x * height, width, height);
    }

    @Override
    public void updateDiskCacheKey(MessageDigest messageDigest) {
        byte[] data = ByteBuffer.allocate(8).putInt(x).putInt(y).array();
        messageDigest.update(data);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        GlideThumbnailTransformation that = (GlideThumbnailTransformation) o;

        if (x != that.x) return false;
        return y == that.y;
    }

    @Override
    public int hashCode() {
        int result = x;
        result = 31 * result + y;
        return result;
    }
}