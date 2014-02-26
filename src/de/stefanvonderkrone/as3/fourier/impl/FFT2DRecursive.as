/**
 * Date: 11.02.14
 * Time: 16:18
 */
package de.stefanvonderkrone.as3.fourier.impl {
    import de.stefanvonderkrone.as3.fourier.isPowerOf2;
    import de.stefanvonderkrone.as3.list.vector.replicate;

    import flash.geom.Point;

    public class FFT2DRecursive implements IFourier2DTransformer {
        public function FFT2DRecursive() {
        }

        public function transform(size:Point, reals:Vector.<Number>, imags:Vector.<Number> = null, inverse:Boolean = false):Boolean {
            if ( imags == null ) {
                imags = Vector.<Number>(replicate(reals.length, 0));
            }
            return reals.length == imags.length ? fft2d( size, reals, imags, inverse ) : false;
        }

        private static function fft2d(size:Point, reals:Vector.<Number>, imags:Vector.<Number>, inverse:Boolean):Boolean {
            // image-width
            const width : int = size.x;
            // image-height
            const height : int = size.y;
            if ( !isPowerOf2( width ) || !isPowerOf2( height ) ) {
                return false;
            }
            // num-pixels
            const l : int = size.x * size.y;
            if ( l != reals.length || l != imags.length ) {
                return false;
            }
            // transform the first dimension
            var m : int = -1;
            var n : int;
            // temp reals/imags
            var tReals : Vector.<Number>;
            var tImags : Vector.<Number>;
            // corresponding reals/imags
//            const cReals : Vector.<Number> = new Vector.<Number>(l, true);
//            const cImags : Vector.<Number> = new Vector.<Number>(l, true);
            var index : int;
            while ( ++m < height ) {
                const startIndex : int = m * width;
                tReals = reals.slice( startIndex, startIndex + width );
                tImags = imags.slice( startIndex, startIndex + width );
                FFTRecursive.transform( tReals, tImags, inverse );
                n = -1;
                while ( ++n < width ) {
                    index = startIndex + n;
                    reals[ int( index ) ] = tReals[ int( n ) ];
                    imags[ int( index ) ] = tImags[ int( n ) ];
                }
            }

            // transform the second dimension
            while ( --n >= 0 ) {
                tReals = new Vector.<Number>(height, true);
                tImags = new Vector.<Number>(height, true);
                m = -1;
                while ( ++m < height ) {
                    index = m * width + n;
                    tReals[ int( m ) ] = reals[ int( index ) ];
                    tImags[ int( m ) ] = imags[ int( index ) ];
                }
                FFTRecursive.transform( tReals, tImags, inverse );
                while ( --m >= 0 ) {
                    index = m * width + n;
                    reals[ int( index ) ] = tReals[ int( m ) ];
                    imags[ int( index ) ] = tImags[ int( m ) ];
                }
            }
            return true;
        }

        public static function transform(size:Point, reals:Vector.<Number>, imags:Vector.<Number> = null, inverse:Boolean = false):Boolean {
            if ( imags == null ) {
                imags = Vector.<Number>(replicate(reals.length, 0));
            }
            return reals.length == imags.length ? fft2d( size, reals, imags, inverse ) : false;
        }
    }
}
