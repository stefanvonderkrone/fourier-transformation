/**
 * Date: 30.12.13
 * Time: 20:37
 */
package de.stefanvonderkrone.as3.fourier.impl {
    import de.stefanvonderkrone.as3.list.vector.replicate;

    import flash.geom.Point;

    public class DFT implements IFourierTransformer {

        /**
         * in-place discrete fourier transformation (dft)
         * @param reals {Vector.<Number>}
         * @param imags {Vector.<Number>}
         * @param inverse {Boolean}
         * @return {Boolean}
         */
//        [Inline]
        private static function dft( reals : Vector.<Number>, imags : Vector.<Number>, inverse : Boolean = false ) : Boolean {
            if ( reals.length != imags.length ) {
                return false;
            }
            const n : int = reals.length;
            const tReals : Vector.<Number> = new Vector.<Number>(n, true);
            const tImags : Vector.<Number> = new Vector.<Number>(n, true);
            const sign : Number = (inverse ? 2 : -2) * Math.PI;
            var i : int = -1;
            while( ++i < n ) {
                var real : Number = 0;
                var imag : Number = 0;
                const t : Number = sign * i / n;
                var k : int = -1;
                while( ++k < n ) {
                    const cos : Number = Math.cos( k * t );
                    const sin : Number = Math.sin( k * t );
                    const tReal : Number = reals[ int( k ) ];
                    const tImag : Number = imags[ int( k ) ];
                    real += (tReal * cos - tImag * sin);
                    imag += (tReal * sin + tImag * cos);
                }
                tReals[ int( i ) ] = real;
                tImags[ int( i ) ] = imag;
            }
            while( --i >= 0 ) {
                reals[ int( i ) ] = inverse ? tReals[ int( i ) ] : (tReals[ int( i ) ] );
                imags[ int( i ) ] = inverse ? tImags[ int( i ) ] : (tImags[ int( i ) ] );
            }
            return true;
        }

        public static function transform( reals : Vector.<Number>, imags : Vector.<Number> = null ) : Boolean {
            if ( imags == null ) {
                imags = Vector.<Number>(replicate(reals.length, 0));
            }
            return reals.length == imags.length ? dft( reals, imags ) : false;
        }

        public function transform(reals:Vector.<Number>, imags:Vector.<Number> = null, inverse:Boolean = false):Boolean {
            if ( imags == null ) {
                imags = Vector.<Number>(replicate(reals.length, 0));
            }
            return reals.length == imags.length ? dft( reals, imags, inverse ) : false;
        }
    }
}