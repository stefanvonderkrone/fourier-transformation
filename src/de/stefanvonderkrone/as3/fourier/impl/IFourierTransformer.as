/**
 * Date: 10.02.14
 * Time: 15:14
 */
package de.stefanvonderkrone.as3.fourier.impl {
    public interface IFourierTransformer {

        function transform( reals : Vector.<Number>, imags : Vector.<Number> = null, inverse : Boolean = false ) : Boolean;

    }
}
