(function ( $ ) {
 
    var root;
 
    $.fn.ppedit = function() { 
    
        root = this.addClass("ppedit-container");
            
        var createBoxbutton = $("<button>Create Box</button>");
        this.append(createBoxbutton);
        createBoxbutton.click(function()
        {
            createBox();
        });
                        
        return this;
    };

    function createBox(options)
    {
        var settings = $.extend({
            left:'50px',
            top:'50px',
            width:'100px',
            height:'200px'
        }, options);
        
        var newBox = $('<div class="ppedit-box"><div>').css(settings);
        root.append(newBox);   
    }
    
    
 
}( jQuery ));