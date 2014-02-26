/**
 * Date: 13.02.14
 * Time: 13:49
 */
package de.stefanvonderkrone.as3.fourier.tests {
    import com.gskinner.performance.MethodTest;
    import com.gskinner.performance.TestSuite;

    import de.stefanvonderkrone.as3.fourier.impl.DFT;

    import de.stefanvonderkrone.as3.list.vector.replicate;

    import flash.display.BitmapData;
    import flash.geom.Rectangle;

    public class DFTTest extends TestSuite {

        private var _bitmapReals : Vector.<Vector.<Number>>;
        private var _bitmapImags : Vector.<Vector.<Number>>;

        public function DFTTest() {
            name = "DFT-Test";
            description = "Testing 1D-DFT";
            tareTest = new MethodTest( tare );
            iterations = 20;
            createBitmaps();
            tests = [
                    new MethodTest( dft, [ _bitmapReals[0], _bitmapImags[ 0 ] ], "size 128", 20, 1, "" ),
                    new MethodTest( dft, [ _bitmapReals[1], _bitmapImags[ 1 ] ], "size 256", 20, 1, "" ),
                    new MethodTest( dft, [ _bitmapReals[2], _bitmapImags[ 2 ] ], "size 512", 20, 1, "" ),
                    new MethodTest( dft, [ _bitmapReals[3], _bitmapImags[ 3 ] ], "size 1024", 20, 1, "" ),
                    new MethodTest( dft, [ _bitmapReals[4], _bitmapImags[ 4 ] ], "size 2048", 20, 1, "" ),
                    new MethodTest( dft, [ _bitmapReals[5], _bitmapImags[ 5 ] ], "size 4096", 20, 1, "" ),
                    new MethodTest( dft, [ _bitmapReals[6], _bitmapImags[ 6 ] ], "size 8192", 20, 1, "" )
            ];
        }

        private function createBitmaps():void {
            _bitmapReals = new <Vector.<Number>>[];
            _bitmapImags = new <Vector.<Number>>[];
            var i : int = -1;
            var size : int = 128;
            while ( ++i < 8 ) {
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
        }

        private static function dft( reals : Vector.<Number>, imags : Vector.<Number> ):void {
            reals = reals.concat();
            imags = imags.concat();
            DFT.transform( reals, imags );
        }

        private static function tare():void {
        }
    }
}
