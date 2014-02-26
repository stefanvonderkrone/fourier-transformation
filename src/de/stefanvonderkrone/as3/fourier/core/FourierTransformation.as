package de.stefanvonderkrone.as3.fourier.core {

    import com.gskinner.performance.PerformanceTest;
    import com.gskinner.performance.TestSuite;

    import de.stefanvonderkrone.as3.fourier.impl.FFT2DNonRecursive;
    import de.stefanvonderkrone.as3.fourier.tests.DFT2DTest;
    import de.stefanvonderkrone.as3.fourier.tests.DFTTest;
    import de.stefanvonderkrone.as3.fourier.tests.FFT2DNonRecursiveStaticTest;
    import de.stefanvonderkrone.as3.fourier.tests.FFT2DNonRecursiveTest;
    import de.stefanvonderkrone.as3.fourier.tests.FFT2DRecursiveTest;
    import de.stefanvonderkrone.as3.fourier.tests.FFTNonRecursiveStaticTest;
    import de.stefanvonderkrone.as3.fourier.tests.FFTNonRecursiveTest;
    import de.stefanvonderkrone.as3.fourier.tests.FFTRecursiveTest;
    import de.stefanvonderkrone.as3.list.vector.flipMatrix;
    import de.stefanvonderkrone.as3.list.vector.replicate;
    import de.stefanvonderkrone.as3.list.vector.toArray;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.UncaughtErrorEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.utils.getTimer;

    public class FourierTransformation extends Sprite {
        private var _tf:TextField;
        public function FourierTransformation() {
            if (stage != null) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function init(evt:Event = null):void {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            initLog();
            initErrorHandler();

            const size : int = 256;
            const bmp0 : Bitmap = new Bitmap( new BitmapData(size, size, false, 0) );
            const bmp1 : Bitmap = new Bitmap( new BitmapData(size, size, false, 0) );
            const bmp2 : Bitmap = new Bitmap( new BitmapData(size, size, false, 0) );
            bmp0.bitmapData.fillRect( new Rectangle( (size - 4)/2, (size - 4)/2, 4, 4 ), 0xFFFFFF );

            const startTime : int = getTimer();
            const realPixels : Vector.<Number> = Vector.<Number>(bmp0.bitmapData.getVector( new Rectangle(0,0,size,size) )
                    .map( function( pixel : uint,...r ) : uint {
                        return pixel & 0xFF;
                    } ));
            const imagPixels : Vector.<Number> = Vector.<Number>(replicate(realPixels.length, 0));
            const fft : FFT2DNonRecursive = new FFT2DNonRecursive( new Point(size,size) );

//            log( DFT2D.transform( new Point(size,size), realPixels, imagPixels ) );
//            log( FFT2DRecursive.transform( new Point(size,size), realPixels, imagPixels ) );
            log( fft.transform( realPixels, imagPixels ) );
//            log( Fourier.fft2D( complexPixels2d, size, size ) );

            const magnitude : Vector.<Number> = realPixels.map( function( real : Number, i : int, v : * ) : Number {
                const imag : Number = imagPixels[ int( i ) ];
                return Math.log( 1 + Math.sqrt( real*real + imag*imag ) );
//                return Math.sqrt( real*real + imag*imag );
            } );
            const magArr : Array = toArray( magnitude );
            const maxMag : Number = Math.max.apply( Math, magArr );
            const minMag : Number = Math.min.apply( Math, magArr );

            const phase : Vector.<Number> = realPixels.map( function( real : Number, i : int, v : * ) : Number {
                const imag : Number = imagPixels[ int( i ) ];
//                return Math.log( Math.PI + (imag == 0 ? 0 : real == 0 ? Math.atan( Infinity ) : Math.atan( imag / real ) ) );
                return imag == 0 ? 0 : real == 0 ? Math.atan( Infinity ) : Math.atan( imag / real );
            } );
            const phaseArr : Array = toArray( phase );
            const maxPhase : Number = Math.max.apply( Math, phaseArr );
            const minPhase : Number = Math.min.apply( Math, phaseArr );
            log( minPhase, maxPhase );

            bmp1.bitmapData.setVector(
                    new Rectangle(0,0,size,size),
                    flipMatrix( new Point(size, size), Vector.<uint>(magnitude.map(
                            function( m : Number,...r ) : uint {
                                const c : int = Math.round( ( m - minMag ) / ( maxMag - minMag ) * 255 );
                                return ( ( c << 16 ) | ( c << 8 ) | c );
                            }
                    )) )
            );

            bmp2.bitmapData.setVector(
                    new Rectangle(0,0,size,size),
                    flipMatrix( new Point(size,size), Vector.<uint>(phase.map(
                            function (p : Number,...r) : uint {
                                const c : int = Math.round( (p - minPhase) / (maxPhase - minPhase) * 255 );
                                return ((c << 16 ) | ( c << 8 ) | c);
                            }
                    )))
            );
            const endTime : int = getTimer();
            log( "2d-transformation needed", (endTime - startTime), "ms" );

            addChild( bmp0 );
            addChild( bmp1 );
            addChild( bmp2 );
            bmp1.y = size;
            bmp2.x = bmp2.y = size;
            y = 100;

            setupAndStartPerformanceTest();
        }

        private function setupAndStartPerformanceTest():void {
            const pt : PerformanceTest = PerformanceTest.getInstance();
            (new <TestSuite>[
                    new FFTNonRecursiveStaticTest(),
                    new FFTNonRecursiveStaticTest(),
                    new FFT2DNonRecursiveStaticTest(),
                    new FFT2DNonRecursiveStaticTest()
//                new DFTTest(),
//                new DFTTest(),
//                new FFTRecursiveTest(),
//                new FFTRecursiveTest(),
//                new FFTNonRecursiveTest(),
//                new FFTNonRecursiveTest(),
//                new DFT2DTest(),
//                new DFT2DTest(),
//                new FFT2DRecursiveTest(),
//                new FFT2DRecursiveTest(),
//                new FFT2DNonRecursiveTest(),
//                new FFT2DNonRecursiveTest()
            ]).forEach( function( testSuite : TestSuite,...r ) : void {
                        testSuite.addEventListener( Event.COMPLETE, handleTestSuiteComplete );
                        pt.queueTestSuite( testSuite );
                    } );
        }

        private function handleTestSuiteComplete(evt:Event):void {
            log( TestSuite( evt.target).toXML() );
        }

        private function initErrorHandler():void {
            loaderInfo.uncaughtErrorEvents.addEventListener( UncaughtErrorEvent.UNCAUGHT_ERROR, function( evt : UncaughtErrorEvent ) : void {
                log( "An Error occured!" );
                log( evt.toString() );
                log( evt.text );
                if ( evt.error is Error ) {
                    log( Error( evt.error ).getStackTrace() );
                }
            } );
        }

        private function initLog():void {
            _tf = TextField( stage.addChild( new TextField() ) );
            _tf.width = stage.stageWidth;
            _tf.height = stage.stageHeight;
        }

        private function log( ...rest ) : void {
            const s : String = rest.join( " " ) + "\n";
            _tf.appendText( s );
        }
    }
}
