/*  
 *   Copyright 2012 OSBI Ltd
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *       http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 */
 
/**
 * The "about us" dialog
 */

/*var AboutModal = Modal.extend({
    initialize: function() {
        _.extend(this.options, {
            title: "About " + v
        });
    },

    events: {
    	'click a' : 'dummy'
    },

    dummy: function() { return true;},
    
    type: "info",
    
    message: Settings.VERSION + "<br>" + 
        "<a  target='_blank' href='http://crdc.creditease.cn'>http://crdc.creditease.cn/</a><br><br>"
        + "Powered by <img width='20px' src='/images/src/meteorite_free.png'  /> <a target='_blank' href='http://crdc.creditease.cn'>http://crdc.creditease.cn/</a> "
});*/

var showVersion = "Davinci 0.1";
var AboutModal = Modal.extend({
    initialize: function() {
        _.extend(this.options, {
            title: "About " + showVersion
        });
    },

    events: {
        'click a' : 'dummy'
    },

    dummy: function() { return true;},

    type: "info",

    message: showVersion + "<br>" +
    "<a  target='_blank' href='http://crdc.creditease.cn'>http://crdc.creditease.cn/</a><br><br>"
    + "Powered by <img width='20px' src='/images/src/meteorite_free.png'  /> <a target='_blank' href='http://crdc.creditease.cn'>http://crdc.creditease.cn/</a> "
});

l