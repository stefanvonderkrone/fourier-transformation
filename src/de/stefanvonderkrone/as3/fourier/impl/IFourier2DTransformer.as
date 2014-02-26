/**
 * Date: 11.02.14
 * Time: 13:25
 */
package de.stefanvonderkrone.as3.fourier.impl {
    import flash.geom.Point;

    public interface IFourier2DTransformer {

        function transform( size : Point, reals : Vector.<Number>, imags : Vector.<Number> = null, inverse : Boolean = false ) : Boolean;

    }
}
