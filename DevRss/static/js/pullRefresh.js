// 滑动开始
var slide = function(obj, offset, callback) {
    var start,
        end,
        isLock = false,
        isCanDo = false,
        isTouchPad = (/hp-tablet/gi).test(navigator.appVersion),
        hasTouch = 'ontouchstart' in window && !isTouchPad;
    var objparent = obj.parent();
    var fn = {
        // move content div
        translate: function(diff) {
            obj.css({
                "-webkit-transform": "translate(0," + diff + "px)",
                "transform": "translate(0," + diff + "px)"
            });
        },
        // set transform time
        setTranslition: function(time) {
            obj.css({
                "-webkit-transition": "all " + time + "s",
                "transition": "all " + time + "s"
            });
        },
        // back to origin position
        back: function() {
            fn.translate(0 - offset);
            // set flag to false.
            isLock = false;
        }
    };
    obj.bind("touchstart", function(e) {
        if (objparent.scrollTop() <= 0 && !isLock) {
            var even = typeof event == "undefined" ? e : event;
            isLock = true;
            isCanDo = true;
            // save current mouse position for end touch event.
            start = hasTouch ? even.touches[0].pageY : even.pageY;
            fn.setTranslition(0);
        }
    });
    obj.bind("touchmove", function(e) {
        if (objparent.scrollTop() <= 0 && isCanDo) {
            var even = typeof event == "undefined" ? e : event;
            end = hasTouch ? even.touches[0].pageY : even.pageY;
            if (start < end) {
                even.preventDefault();
                fn.setTranslition(0);
                fn.translate(end - start - offset);
            }
        }
    });
    obj.bind("touchend", function(e) {
        // end - start >= offset is not enough, 
        // should vali posiiton, child item is visible.
        if (isCanDo) {
            isCanDo = false;
            if (end - start >= offset) {
                fn.setTranslition(.25);
                fn.translate(0);
                if (typeof callback == "function") {
                    callback.call(fn, e);
                }
            } else {
                fn.back();
            }
        }
    });
}

export default slide;