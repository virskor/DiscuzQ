(function () {
    window.addEventListener("flutterInAppWebViewPlatformReady", function (_) {
        /**
         * 获取APP中的accessToken
         */
        window.flutter_inappwebview.callHandler('getAccessToken').then(function (token) {
            if (token) {
                window.localStorage.setItem('access_token', token);
            }
        });
        /**
         * 获取APP中登录用户的信息
         */
        window.flutter_inappwebview.callHandler('getCurrentUser').then(function (currentUser) {
            var user = JSON.parse(currentUser);
            if (user) {
                window.localStorage.setItem('user_id', user.id);
            }
        });
    });

    window.onload = function(){
        /**
         * 隐藏导航栏
         */
        var backNavigation = document.querySelector('.qui-back');
        if(backNavigation){
            backNavigation.style.display = 'none';
        }
        
        /**
         * 移除缩进
         */
        var pagePadding = document.querySelector('.qui-page--padding');
        if(pagePadding){
            pagePadding.style.paddingTop = '0';
        }
    }
})();