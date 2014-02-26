/**
 * Date: 25.02.14
 * Time: 11:38
 */

$(function($) {
    "use strict";

    var c = window.console,
        doc = document,
        _ = window._;

    function processData( $data ) {
        var $testSuites = _.map( _.filter( $data.find( "TestSuite" ), function( t, i ) {
            return !!(i & 1);
        } ), $ );
        _.each( $testSuites, function( $testSuite ) {
            c.log( $testSuite.attr( "name" ) + " (" + $testSuite.attr( "description" ) + "):"  );
            _.each( $testSuite.find( "MethodTest" ), function( methodTest ) {
                var $methodTest = $( methodTest );
                c.log( "\t" + $methodTest.attr( "name" ) + ":" );
                c.log( "\t\t" + $methodTest.attr( "time" ) + "ms (+/-" + $methodTest.attr( "timeDeviation" ) + ")" );
                c.log( "\t\t" + $methodTest.attr( "memory" ) + "kb (+/-" + $methodTest.attr( "memoryDeviation" ) + ")" );
            } );
        } );
    }

    $.ajax( {
        success: function( data ) {
            processData( $( data ) );
        },
        type: "get",
        url: "benchmark-results.xml"
    } )

});