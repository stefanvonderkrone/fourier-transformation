/**
 * Date: 11.02.14
 * Time: 12:35
 */
package de.stefanvonderkrone.as3.fourier {

    [Inline]
    public function isPowerOf2(n:int):Boolean {
        var x : int = 1;
        while ( x < n ) {
            x *= 2;
        }
        return x == n;
    }
}
