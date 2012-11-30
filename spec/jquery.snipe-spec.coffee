buster.spec.expose()

describe "jquery.snipe", ->

	describe "exposure", ->

		it "should be exposed in jQuery API", ->
			expect($.fn.snipe).toBeDefined()

	describe "setup", ->

		before ->
			@el = $('<a href="#"><img src="#"></a>')
			@snipe = @el.snipe()

		it "should return the element", ->
			expect($(@snipe)).toBe(@el)