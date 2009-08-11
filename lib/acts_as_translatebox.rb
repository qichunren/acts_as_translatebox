# ActsAsTranslatebox
module ActsAsTranslatebox
  
  def self.included(base)
    #base.send :class_inheritable_hash, :unicorn_options
    #base.unicorn_options = {}
    
    #base.send :helper_method,  :unicorn_html
    
    base.send :include, InstanceMethods
    base.send :extend,  ClassMethods
  end

  module ClassMethods
    def acts_as_translatebox(*args)
      self.unicorn_options = {:link_text => args.shift} if args.first.is_a?(String)
      after_filter :insert_translatebox_html, (args.first||{})
    end
  end
  
  module InstanceMethods
    def insert_translatebox_html
      #oh no string concatination. my unicorns aren't scaling
      translatebox_html = <<-HTML
<script type="text/javascript" src="http://www.google.com/jsapi"></script>
<script type="text/javascript">
google.load("language", "1");

function translate_it(){
  var the_words = document.getElementById("words").value;
  google.language.detect(the_words, function(result) {
  if (!result.error && result.language) {
    google.language.translate(the_words, result.language, "en",
                                    function(result) {
            var translated = document.getElementById("target");
            if (result.translation) {
              translated.innerHTML = result.translation;
            }
          });
        }
      });

		}
    </script>
<style type="text/css">
  div#chat_button {
    text-align: right;
    position: fixed;
    bottom: 0px;
    right: 10px;
    width: 80px;
    border: 1px solid #ccc;
    padding: 2px;
    vertical-align: middle;
    background-color: #eee;
}
div#chat_input {
    position: fixed;
    bottom: 25px;
    padding:5px;
    right: 10px;
    border:1px solid #BDBDBD;
    background:#E0E0E0;
}
* html div#chat_input {
    position: absolute;
    right: auto; bottom: auto;
    left: expression( ( 0 - chat_input.offsetWidth + ( document.documentElement.clientWidth ? document.documentElement.clientWidth : document.body.clientWidth ) + ( ignoreMe2 = document.documentElement.scrollLeft ? document.documentElement.scrollLeft : document.body.scrollLeft ) ) + 'px' );
    top: expression( ( -25 - chat_input.offsetHeight + ( document.documentElement.clientHeight ? document.documentElement.clientHeight : document.body.clientHeight ) + ( ignoreMe = document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop ) ) + 'px' );
}

* html div#chat_button {
    position: absolute;
    right: auto; bottom: auto;
    left: expression( ( 0 - chat_button.offsetWidth + ( document.documentElement.clientWidth ? document.documentElement.clientWidth : document.body.clientWidth ) + ( ignoreMe2 = document.documentElement.scrollLeft ? document.documentElement.scrollLeft : document.body.scrollLeft ) ) + 'px' );
    top: expression( ( 0 - chat_button.offsetHeight + ( document.documentElement.clientHeight ? document.documentElement.clientHeight : document.body.clientHeight ) + ( ignoreMe = document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop ) ) + 'px' );
}

  </style>
  <div id="chat_input" style="display:none;">
   <form>
     <input id='words' type="text" style="width:280px;vertical-align:middle;"/>
     <input type='button' value='翻译' style="vertical-align:middle;" onclick="translate_it()"/>
     </form>
    <div id="target" style="width:280px;height:80px;border:1px solid #FF9900;background:#FFF;" ></div>
  </div>
  <div id="chat_button">
    <a href="#" style="text-decoration:none;color:black" onclick="$('chat_input').toggle();return false;">翻译助手</a>
  </div>      
      HTML
      response.body = response.body.to_s + translatebox_html 
    end
  end
  
end

ActionController::Base.send :include, ActsAsTranslatebox
