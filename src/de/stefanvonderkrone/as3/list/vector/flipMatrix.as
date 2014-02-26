/**
 * Date: 12.02.14
 * Time: 15:50
 */
package de.stefanvonderkrone.as3.list.vector {
    import flash.geom.Point;

    [Inline]
    public function flipMatrix( size : Point, matrix : * ) : * {
        const width : int = size.x;
        const height : int = size.y;
        const wHalf : int = width >> 1;
        const hHalf : int = height >> 1;
        const l : int = width * height;
        const result : * = matrix.concat();
        if ( matrix.length < l ) {
            throw new Error( "size must be lesser or equal of matrix-length!" );
        }
        var y : int = -1;
        while ( ++y < height ) {
            const targetY : int = y < hHalf ? (y + hHalf) : (y - hHalf);
            var x : int = -1;
            while ( ++x < width ) {
                const targetX : int = x < wHalf ? (x + wHalf) : (x - wHalf);
                const index : int = y * width + x;
                const targetIndex : int = targetY * width + targetX;
                result[ int( targetIndex ) ] = matrix[ int( index ) ];
            }
        }
        return result;
    }
}
