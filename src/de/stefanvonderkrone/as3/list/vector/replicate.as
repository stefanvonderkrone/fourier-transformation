/**
 * Date: 10.02.14
 * Time: 15:10
 */
package de.stefanvonderkrone.as3.list.vector {

//    [Inline]
    public function replicate( num : int, val : * ) : Vector.<*> {
        const vec : Vector.<*> = new Vector.<*>(num);
        var i : int = -1;
        while ( ++i < num ) {
            vec[ int( i ) ] = val;
        }
        return vec;
    }
}
