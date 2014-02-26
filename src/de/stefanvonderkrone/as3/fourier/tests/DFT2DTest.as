/**
 * Date: 13.02.14
 * Time: 13:49
 */
package de.stefanvonderkrone.as3.fourier.tests {
    import com.gskinner.performance.MethodTest;
    import com.gskinner.performance.TestSuite;

    import de.stefanvonderkrone.as3.fourier.impl.DFT;
    import de.stefanvonderkrone.as3.fourier.impl.DFT2D;

    import de.stefanvonderkrone.as3.list.vector.replicate;

    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class DFT2DTest extends TestSuite {

        private var _bitmapReals : Vector.<Vector.<Number>>;
        private var _bitmapImags : Vector.<Vector.<Number>>;

        public function DFT2DTest() {
            name = "2D-DFT-Test";
            description = "Testing 2D-DFT";
            iterations = 20;
            createBitmaps();
            tareTest = new MethodTest( tare );
            tests = [
                    new MethodTest( dft, [ _bitmapReals[0], _bitmapImags[ 0 ] ], "size 8x8", 20, 1, "" ),
                    new MethodTest( dft, [ _bitmapReals[1], _bitmapImags[ 1 ] ], "size 16x16", 20, 1, "" ),
                    new MethodTest( dft, [ _bitmapReals[2], _bitmapImags[ 2 ] ], "size 32x32", 20, 1, "" ),
                    new MethodTest( dft, [ _bitmapReals[3], _bitmapImags[ 3 ] ], "size 64x64", 20, 1, "" )
            ];
        }

        private function createBitmaps():void {
            _bitmapReals = new <Vector.<Number>>[];
            _bitmapImags = new <Vector.<Number>>[];
            var i : int = -1;
            var size : int = 8;
            while ( ++i < 4 ) {
                const bmp : BitmapData = new BitmapData( size, size, false, 0 );
                bmp.fillRect( new Rectangle( (size - 4) >> 1, (size - 4) >> 1, 4, 4 ), 0xFFFFFF );
                _bitmapReals.push(
                        Vector.<Number>( bmp.getVector( new Rectangle(0, 0, size, size) ) ).map(
                                function( p : Number,...r ) : Number {
                                    return p & 0xFF;
                                }
                        )
                );
                _bitmapImags.push( Vector.<Number>( replicate( size * size, 0 ) ) );
                size <<= 1;
            }
        }

        private static function dft( reals : Vector.<Number>, imags : Vector.<Number> ):void {
            reals = reals.concat();
            imags = imags.concat();
            const size : Number = Math.sqrt( reals.length );
            const p : Point = new Point( size, size );
            DFT2D.transform( p, reals, imags );
        }

        private static function tare():void {
        }
    }
}
