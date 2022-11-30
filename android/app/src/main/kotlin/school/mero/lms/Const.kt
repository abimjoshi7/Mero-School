package school.mero.lms

import kotlin.math.floor
public const val DATABASE_VERSION = 15

fun Double.toFixed2Digit(): Double{
    return floor(this * 100) / 100;
}

const val SHOW_SPRITES = false;