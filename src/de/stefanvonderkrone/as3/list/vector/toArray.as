/**
 * Date: 11.02.14
 * Time: 17:41
 */
package de.stefanvonderkrone.as3.list.vector {

    [Inline]
    public function toArray( vec : * ) : Array {
        const l : int = vec.length;
        const a : Array = [];
        a.length = l;
        var i : int = -1;
        while ( ++i < l ) {
            a[ int( i ) ] = vec[ int( i ) ];
        }
        return a;
    }
}
