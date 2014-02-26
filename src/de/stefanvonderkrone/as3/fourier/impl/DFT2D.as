/**
 * Date: 11.02.14
 * Time: 13:24
 */
package de.stefanvonderkrone.as3.fourier.impl {
    import de.stefanvonderkrone.as3.list.vector.replicate;

    import flash.geom.Point;

    public class DFT2D implements IFourier2DTransformer {
        public function DFT2D() {
        }

        public function transform(size:Point, reals:Vector.<Number>, imags:Vector.<Number> = null, inverse:Boolean = false):Boolean {
            if ( imags == null ) {
                imags = Vector.<Number>(replicate(reals.length, 0));
            }
            return reals.length == imags.length ? dft2d( size, reals, imags, inverse ) : false;
        }

        [Inline]
        private static function dft2d(size:Point,reals:Vector.<Number>, imags:Vector.<Number>, inverse : Boolean = false): Boolean{
            // image-width
            const width : int = size.x;
            // image-height
            const height : int = size.y;
            // num-pixels
            const l : int = width * height;
            if ( l != reals.length || l != imags.length ) {
                return false;
            }
            // temp reals
            const tReals : Vector.<Number> = new Vector.<Number>(l, true);
            // temp imags
            const tImags : Vector.<Number> = new Vector.<Number>(l, true);
            // row-index u
            var u : int = -1;
            // const sign based on inverse-bool
            const sign : Number = (inverse ? 2 : -2) * Math.PI;
            // for each row
            while ( ++u < height ) {
                // column-index v
                var v : int = -1;
                // for each column
                while ( ++v < width ) {
                    // (u,v)-index
                    const index : int = u * width + v;
                    // row-index m
                    var m : int = -1;
                    tReals[ int( index ) ] = 0;
                    tImags[ int( index ) ] = 0;
                    // for each row
                    while ( ++m < height ) {
                        // temp complex
                        var tReal : Number = 0;
                        var tImag : Number = 0;
                        // column-index n
                        var n : int = -1;
                        // angle represented by complex
                        var theta : Number;
                        var cosArg : Number;
                        var sinArg : Number;
                        // for each column
                        while ( ++n < width ) {
                            theta = sign * n * v / width;
                            // real
                            cosArg = Math.cos( theta );
                            // imag
                            sinArg = Math.sin( theta );
                            // (m,n)-index
                            const cIndex : int = m * width + n;
                            // given complex from reals[]/imags[]
                            const cReal : Number = reals[ int( cIndex ) ];
                            const cImag : Number = imags[ int( cIndex ) ];
                            tReal += cReal * cosArg - cImag * sinArg;
                            tImag += cReal * sinArg + cImag * cosArg;
                        }
                        theta = sign * m * u / height;
                        cosArg = Math.cos( theta );
                        sinArg = Math.sin( theta );
                        tReals[ int( index ) ] += tReal * cosArg - tImag * sinArg;
                        tImags[ int( index ) ] += tReal * sinArg + tImag * cosArg;
                    }
                }
            }
            // copy back the data
            var i : int = -1;
            while ( ++i < l ) {
                reals[ int( i ) ] = tReals[ int( i ) ];
                imags[ int( i ) ] = tImags[ int( i ) ];
            }
            return true;
        }

        public static function transform(size:Point, reals:Vector.<Number>, imags:Vector.<Number> = null, inverse:Boolean = false):Boolean {
            if ( imags == null ) {
                imags = Vector.<Number>(replicate(reals.length, 0));
            }
            return reals.length == imags.length ? dft2d( size, reals, imags, inverse ) : false;
        }
    }
}
