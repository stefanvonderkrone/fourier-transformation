/**
 * Date: 13.02.14
 * Time: 13:49
 */
package de.stefanvonderkrone.as3.fourier.tests {
    import com.gskinner.performance.MethodTest;
    import com.gskinner.performance.TestSuite;

    import de.stefanvonderkrone.as3.fourier.impl.DFT;
    import de.stefanvonderkrone.as3.fourier.impl.FFTRecursive;

    import de.stefanvonderkrone.as3.list.vector.replicate;

    import flash.display.BitmapData;
    import flash.geom.Rectangle;

    public class FFTRecursiveTest extends TestSuite {

        private var _bitmapReals : Vector.<Vector.<Number>>;
        private var _bitmapImags : Vector.<Vector.<Number>>;

        public function FFTRecursiveTest() {
            name = "FFT-Test (recursive)";
            description = "Testing 1D-FFT (recursive)";
            tareTest = new MethodTest( tare );
            iterations = 20;
            createBitmaps();
            tests = [
                    new MethodTest( fft, [ _bitmapReals[0], _bitmapImags[ 0 ] ], "size 128", 20, 1, "" ),
                    new MethodTest( fft, [ _bitmapReals[1], _bitmapImags[ 1 ] ], "size 256", 20, 1, "" ),
                    new MethodTest( fft, [ _bitmapReals[2], _bitmapImags[ 2 ] ], "size 512", 20, 1, "" ),
                    new MethodTest( fft, [ _bitmapReals[3], _bitmapImags[ 3 ] ], "size 1024", 20, 1, "" ),
                    new MethodTest( fft, [ _bitmapReals[4], _bitmapImags[ 4 ] ], "size 2048", 20, 1, "" ),
                    new MethodTest( fft, [ _bitmapReals[5], _bitmapImags[ 5 ] ], "size 4096", 20, 1, "" ),
                    new MethodTest( fft, [ _bitmapReals[6], _bitmapImags[ 6 ] ], "size 8192", 20, 1, "" ),
                    new MethodTest( fft, [ _bitmapReals[7], _bitmapImags[ 7 ] ], "size 16384", 20, 1, "" ),
                    new MethodTest( fft, [ _bitmapReals[8], _bitmapImags[ 8 ] ], "size 32768", 20, 1, "" ),
                    new MethodTest( fft, [ _bitmapReals[9], _bitmapImags[ 9 ] ], "size 65536", 20, 1, "" ),
                    new MethodTest( fft, [ _bitmapReals[10], _bitmapImags[ 10 ] ], "size 131072", 20, 1, "" ),
                    new MethodTest( fft, [ _bitmapReals[11], _bitmapImags[ 11 ] ], "size 262144", 20, 1, "" ),
                    new MethodTest( fft, [ _bitmapReals[12], _bitmapImags[ 12 ] ], "size 524288", 20, 1, "" ),
                    new MethodTest( fft, [ _bitmapReals[13], _bitmapImags[ 13 ] ], "size 1048576", 20, 1, "" )
            ];
        }

        private function createBitmaps():void {
            _bitmapReals = new <Vector.<Number>>[];
            _bitmapImags = new <Vector.<Number>>[];
            var i : int = -1;
            var size : int = 128;
            while ( ++i < 14 ) {
                const bmp : BitmapData = new BitmapData( size, 1, false, 0 );
                bmp.fillRect( new Rectangle( (size - 4) >> 1, 0, 4, 1 ), 0xFFFFFF );
                _bitmapReals.push(
                        Vector.<Number>( bmp.getVector( new Rectangle(0, 0, size, 1) ) ).map(
                                function( p : Number,...r ) : Number {
                                    return p & 0xFF;
                                }
                        )
                );
                _bitmapImags.push( Vector.<Number>( replicate( size, 0 ) ) );
                size <<= 1;
            }
            trace( _bitmapReals.join("\n") );
        }

        private static function fft( reals : Vector.<Number>, imags : Vector.<Number> ):void {
            reals = reals.concat();
            imags = imags.concat();
            FFTRecursive.transform( reals, imags );
        }

        private static function tare():void {
        }
    }
}
