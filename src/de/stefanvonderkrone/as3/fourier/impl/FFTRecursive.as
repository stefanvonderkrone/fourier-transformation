/**
 * Date: 03.01.14
 * Time: 15:33
 */
package de.stefanvonderkrone.as3.fourier.impl {
    import de.stefanvonderkrone.as3.fourier.isPowerOf2;
    import de.stefanvonderkrone.as3.list.vector.replicate;

    public class FFTRecursive implements IFourierTransformer {

        public static function transform( reals : Vector.<Number>, imags : Vector.<Number> = null, inverse : Boolean = false ) : Boolean {
            if ( imags == null ) {
                imags = Vector.<Number>(replicate(reals.length, 0));
            }
            if ( !isPowerOf2( reals.length ) || reals.length != imags.length ) {
                return false;
            }
            return fft( reals, imags, (inverse ? 2 : -2) * Math.PI );
        }

        [Inline]
        private static function fft( reals : Vector.<Number>, imags : Vector.<Number>, sign : Number ) : Boolean {
            const l : int = reals.length;
            if ( l <= 1 ) {
                return true;
            }
            const n : int = l >> 1;
            const realsEven : Vector.<Number> = new Vector.<Number>(n, true);
            const imagsEven : Vector.<Number> = new Vector.<Number>(n, true);
            const realsOdd : Vector.<Number> = new Vector.<Number>(n, true);
            const imagsOdd : Vector.<Number> = new Vector.<Number>(n, true);
            var i : int = -1;
            while ( ++i < n ) {
                realsEven[ int( i ) ] = reals[ int( i * 2 ) ];
                imagsEven[ int( i ) ] = imags[ int( i * 2 ) ];
                realsOdd[ int( i ) ] = reals[ int( i * 2 + 1 ) ];
                imagsOdd[ int( i ) ] = imags[ int( i * 2 + 1 ) ];
            }
            if ( n > 1 ) {
                fft( realsEven, imagsEven, sign );
                fft( realsOdd, imagsOdd, sign );
            }
            // manage odds
            while ( --i >= 0 ) {
                const tReal : Number = realsOdd[ int( i ) ];
                const tImag : Number = imagsOdd[ int( i ) ];
                // exp( k, n ) * (real, imag)
                // exp(k,n) = cis( sign * k / n )
                const theta : Number = sign * i / l;
                const expReal : Number = Math.cos( theta );
                const expImag : Number = Math.sin( theta );
                realsOdd[ int( i ) ] = expReal * tReal - expImag * tImag;
                imagsOdd[ int( i ) ] = expReal * tImag + expImag * tReal;
            }
            // manage evens
            while ( ++i < n ) {
                const realEven : Number = realsEven[ int( i ) ];
                const imagEven : Number = imagsEven[ int( i ) ];
                const realOdd : Number = realsOdd[ int( i ) ];
                const imagOdd : Number = imagsOdd[ int( i ) ];
                reals[ int( i ) ] = realEven + realOdd;
                imags[ int( i ) ] = imagEven + imagOdd;
                reals[ int( n + i ) ] = realEven - realOdd;
                imags[ int( n + i ) ] = imagEven - imagOdd;
            }
            return true;
        }

        public function transform(reals:Vector.<Number>, imags:Vector.<Number> = null, inverse:Boolean = false):Boolean {
            if ( imags == null ) {
                imags = Vector.<Number>(replicate(reals.length, 0));
            }
            if ( !isPowerOf2( reals.length ) || reals.length != imags.length ) {
                return false;
            }
            return fft( reals, imags, (inverse ? 2 : -2) * Math.PI );
        }
    }
}
