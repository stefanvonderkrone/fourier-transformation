/**
 * Date: 11.02.14
 * Time: 16:49
 */
package de.stefanvonderkrone.as3.fourier.impl {
    import de.stefanvonderkrone.as3.fourier.isPowerOf2;
    import de.stefanvonderkrone.as3.list.vector.replicate;

    import flash.geom.Point;

    public class FFT2DNonRecursive implements IFourierTransformer {

        private var _width : int;
        private var _height : int;
        private var _horizontalFFT : FFTNonRecursive;
        private var _verticalFFT : FFTNonRecursive;

        public function FFT2DNonRecursive(size : Point) {
            _width = size.x;
            _height = size.y;
            if ( !isPowerOf2( _width ) || !isPowerOf2( _height ) ) {
                throw new Error( "The Dimensions must be power of 2!" );
            }
            _horizontalFFT = new FFTNonRecursive( _width );
            _verticalFFT = new FFTNonRecursive( _height );
        }

//        [Inline]
        public final function transform(reals:Vector.<Number>, imags:Vector.<Number> = null, inverse:Boolean = false):Boolean {
            if ( imags == null ) {
                imags = Vector.<Number>(replicate(reals.length, 0));
            }
            return reals.length == imags.length ? fft2d( reals, imags, inverse ) : false;
        }

        [Inline]
        private final function fft2d(reals:Vector.<Number>, imags:Vector.<Number>, inverse:Boolean):Boolean {
            // num-pixels
            const l : int = _width * _height;
            if ( l != reals.length || l != imags.length ) {
                return false;
            }
            // transform the first dimension
            var m : int = -1;
            var n : int;
            var tReals : Vector.<Number>;
            var tImags : Vector.<Number>;
            var index : int;
            while ( ++m < _height ) {
                const startIndex : int = m * _width;
                tReals = reals.slice( startIndex, startIndex + _width );
                tImags = imags.slice( startIndex, startIndex + _width );
                _horizontalFFT.transform( tReals, tImags, inverse );
                n = -1;
                while ( ++n < _width ) {
                    index = startIndex + n;
                    reals[ int( index ) ] = tReals[ int( n ) ];
                    imags[ int( index ) ] = tImags[ int( n ) ];
                }
            }

            // transform the second dimension
            while ( --n >= 0 ) {
                tReals = new Vector.<Number>(_height, true);
                tImags = new Vector.<Number>(_height, true);
                m = -1;
                while ( ++m < _height ) {
                    index = m * _width + n;
                    tReals[ int( m ) ] = reals[ int( index ) ];
                    tImags[ int( m ) ] = imags[ int( index ) ];
                }
                _verticalFFT.transform( tReals, tImags, inverse );
                while ( --m >= 0 ) {
                    index = m * _width + n;
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
            return reals.length == imags.length ? (new FFT2DNonRecursive(size)).transform( reals, imags, inverse ) : false;
        }
    }
}
