
function handleMessage(gameId, bookId, width, broadcasterName, userId, widthUnit) {
    console.log('handleMessage details=', gameId, bookId, width, broadcasterName, userId, widthUnit);
    try {
        if(!broadcasterName) {
            broadcasterName = 'NFL';
        }
        if(!bookId) {
            bookId = '1000009';
        }
        if(!userId) {
            userId = 'USR1234';
        }
        if(!widthUnit) {
            widthUnit = 'px';
        }

        if(gameId && bookId){
            //            Dynamically create a placeholder div for panel
            createDivForReactNative(gameId, bookId, width, broadcasterName, userId, widthUnit);
            //            Load all the react native scripts
            loadReactLiveScripts();
            //            Helper functions
            //            helperTapppFn(gameId, bookId, width);
        }
    } catch(e) {
        console.log('...Error on handle message', e);
        document.getElementById('errorTag').innerHTML = "Oops something went wrong ...."+e;
    }
}

//    Create root div for the Panel library
    function createDivForReactNative(gameId, bookId, width, broadcasterName, userId, widthUnit) {
        const rootDiv = document.createElement('div');
        const rootTag = "<div id='tappp-panel' userid='"+ userId +"' bookid='"+ bookId +"' gameid='"+ gameId +"' width='"+ width +"' widthunit='" + widthUnit +"' broadcastername='" + broadcasterName + "' ></div>";
        console.log('...rootTag=', rootTag);
        rootDiv.innerHTML = rootTag;
        document.body.appendChild(rootDiv);
    }

// Load react live script
    function loadReactLiveScripts() {
        const scriptTag = document.createElement('script');
        scriptTag.type = 'text/javascript';
        scriptTag.src = "https://dev-demo-nfl.tappp.com/mobile/bundle.js";
        document.body.appendChild(scriptTag);
    }

// Load react script tags on
    function loadReactScripts() {
        let reactScripts = ["2.502c0d23.chunk", "app.31298c61.chunk", "runtime~app.c09eef9e"];

        for(let script of reactScripts) {
            if(script) {
                const scriptTag = document.createElement('script');
                scriptTag.type = 'text/javascript';
                scriptTag.src = "https://dev-demo-nfl.tappp.com/mobile/bundle.js";
                document.body.appendChild(scriptTag);
            }
        }
    }
    
//    Do specific thing once the script loaded
    function callFunctionFromScript(gameId, bookId, width, calledFrom) {
        console.log('Test');
        const scritpTagFn = 'scriptOnloadTag';
        const divErr = document.createElement('div');
        divErr.innerHTML = calledFrom;
        document.getElementById(scritpTagFn).appendChild(divErr);
    }
    
    function helperTapppFn(gameId, bookId, width) {
        const helperDiv = document.createElement('div');
        let gameTag = "<input type='text' name='value' id='gameId' value='"+gameId+"' />";
        let bookTag = "<input type='text' name='value' id='bookId' value='"+bookId+"' />";
        let widthTag = "<input type='text' name='value' id='widthId' value='"+width+"' />";
        
        helperDiv.innerHTML = gameTag + bookTag + widthTag +`
            <label>
              <input type="checkbox" name="check" value="1" /> Checked?
            </label>
            <input type="button" value="-" onclick="removeRow(this)" />
          `;
        document.getElementById('parentId').appendChild(helperDiv);
    }
    


function showData(){
//    console.log("showData called", gamedataObjectFromReferencePanel);
//    document.getElementById('nameField').value = "xyz";
}

function fillDetailNew(){
    //let nameField = document.getElementById('nameField').value;
    //var email = document.getElementById("email").value;
//    document.getElementById('welcome').innerHTML = "HTML static data";
}

/*function showPanelData(jsonString) {
    //window.webkit.messageHandlers.postScript.postMessage(jsonString)
    document.getElementById('welcome').innerHTML = jsonString;
}*/
function callNative() {
    webkit.messageHandlers.callNative.postMessage({
        "message": "callNative method data passes"
    });
}

function nativeToJs(objPanelData){
    console.log("....objPanelData in js=", objPanelData)
}

function showiOSToast() {
    let nameField = document.getElementById('nameField').value;
    webkit.messageHandlers.toggleMessageHandler.postMessage({
        "message": nameField
    });
}
