describe("jquery.snipe", function() {

    var el = undefined;
    var snipe = undefined;

    describe('loading the script', function(){
        it("should be exposed in jQuery API",function(){
            expect($.fn.snipe).toBeDefined()
        });
    });

    describe('initializing the plugin with defaults settings', function(){

        var el, snipe;
        el    = $('#test1');
        chain = el.snipe();
        snipe = el.data('snipe');

        it("should return the element",function(){
            expect(chain).toBe(el)
        });
        it("instance should be stored in element data",function(){
            expect(el.data('snipe')).toBeDefined()
        });
    });

    describe('initializing the plugin with custom settings', function(){
        var el, snipe;
        el = $('#test2');
        el.snipe({
            'class': 'custom-snipe',
            'css': {
                'border': '5px solid white'
            }
        });
        snipe = el.data('snipe')


        it("should have custom class on the lens",function(){
            expect($('.custom-snipe').length).not.toBe(0);
        });

        it("should have deep merged the settings object (css)",function(){
            expect(snipe.settings.css.border).toBe('5px solid white');
        });

    });

    describe('reflows', function(){
        reflow = $('#reflow').height('200');
        
    })
});