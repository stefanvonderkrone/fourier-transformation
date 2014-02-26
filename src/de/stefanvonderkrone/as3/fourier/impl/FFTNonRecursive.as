/**
 * Date: 30.12.13
 * Time: 20:37
 */
package de.stefanvonderkrone.as3.fourier.impl {
    import de.stefanvonderkrone.as3.fourier.isPowerOf2;
    import de.stefanvonderkrone.as3.list.vector.replicate;

    public class FFTNonRecursive implements IFourierTransformer {

        private var _size : int;
        private var _sizeLog2 : int;
        private var _inverse:Number;

        private var _elements : Vector.<FFTItem>;

        public function FFTNonRecursive( fftSize : int ) {
            _size = fftSize;
            _sizeLog2 = getLog2( fftSize );
            _inverse = 1 / _size;
            _elements = new Vector.<FFTItem>(fftSize, true);
            var k : int = fftSize;
            var last : FFTItem;
            var element : FFTItem;
            while ( --k >= 0 ) {
                _elements[ int( k ) ] = element = new FFTItem();
                if ( last != null )
                    element.next = last;
                element.brTargetIndex = bitReverse( k, _sizeLog2 );
                last = element;
            }
        }

        [Inline]
        private static function bitReverse(x:int, numBits:int):int {
            var y:uint = 0;
            for ( var i:uint = 0; i < numBits; i++)
            {
                y <<= 1;
                y |= x & 0x0001;
                x >>= 1;
            }
            return y;
        }

        [Inline]
        private static function getLog2(i:int):int {
            var x : int = 1;
            var n : int = 0;
            while ( x < i ) {
                x *= 2;
                ++n;
            }
            if ( x != i ) {
                throw new Error( "The FFT-Size must be power of 2!" );
            }
            return n;
        }

        public static function transform(reals:Vector.<Number>, imags:Vector.<Number> = null, inverse:Boolean = false):Boolean {
            if ( imags == null ) {
                imags = Vector.<Number>(replicate(reals.length, 0));
            }
            if ( !isPowerOf2( reals.length ) || reals.length != imags.length ) {
                return false;
            }
            return (new FFTNonRecursive(reals.length)).transform( reals, imags, inverse );
        }

//        [Inline]
        public final function transform(reals:Vector.<Number>, imags:Vector.<Number> = null, inverse:Boolean = false):Boolean {
            if ( imags == null ) {
                imags = Vector.<Number>(replicate(reals.length, 0));
            }
            if ( !isPowerOf2( reals.length ) || reals.length != imags.length ) {
                return false;
            }
            return fft( reals, imags, inverse );
        }

        [Inline]
        private final function fft(reals:Vector.<Number>, imags:Vector.<Number>, inverse:Boolean):Boolean {

            // copy data in FFTElements-List
            var el : FFTItem = _elements[0];
            var k : int = 0;
            var scale : Number = inverse ? _inverse : 1;
            while ( el != null ) {
                el.real = scale * reals[ int( k ) ];
                el.imag = scale * imags[ int( k ) ];
                el = el.next;
                ++k;
            }

            var numElements : int = _size >> 1;
            var span : int = numElements;
            var spacing : int = _size;
            var indexStep : int = 1;
            const sign : Number = (inverse ? 2 : -2) * Math.PI / _size;

            // calculate the fft
            var logIndex : int = -1;
            while ( ++logIndex < _sizeLog2 ) {
                const angle : Number = indexStep * sign;
                const cosArg : Number = Math.cos( angle );
                const sinArg : Number = Math.sin( angle );

                var start : int = 0;
                while ( start < _size ) {
                    var elStart : FFTItem = _elements[ int( start ) ];
                    var elEnd : FFTItem = _elements[ int( start + span ) ];

                    var real : Number = 1;
                    var imag : Number = 0;

                    var i : int = -1;
                    while ( ++i < numElements ) {
                        const startReal : Number = elStart.real;
                        const startImag : Number = elStart.imag;
                        var endReal : Number = elEnd.real;
                        var endImag : Number = elEnd.imag;

                        elStart.real = startReal + endReal;
                        elStart.imag = startImag + endImag;

                        endReal = startReal - endReal;
                        endImag = startImag - endImag;
                        elEnd.real = endReal * real - endImag * imag;
                        elEnd.imag = endReal * imag + endImag * real;

                        elStart = elStart.next;
                        elEnd = elEnd.next;

                        const tReal : Number = real;
                        real = real * cosArg - imag * sinArg;
                        imag = tReal * sinArg + imag * cosArg;
                    }
                    start += spacing;
                }

                // divide by 2 by right shift
                numElements >>= 1;
                span >>= 1;
                spacing >>= 1;
                // multiply by 2 by left shift
                indexStep <<= 1;
            }

            // copy data back
            el = _elements[ 0 ];
            while ( el != null ) {
                reals[ int( el.brTargetIndex ) ] = el.real;
                imags[ int( el.brTargetIndex ) ] = el.imag;
                el = el.next;
            }

            return true;
        }
    }
}

internal final class FFTItem {
    /**
     * real component
     */
    public var real : Number = 0;

    /**
     * imaginary component
     */
    public var imag : Number = 0;

    /**
     * linked-list next element
     */
    public var next : FFTItem;

    /**
     * bit-reverse target index
     */
    public var brTargetIndex : int;
}
