function notify(message, type, timeout) {
	// default values
	message = typeof message !== 'undefined' ? message : 'Hello!';
	type = typeof type !== 'undefined' ? type : 'success';
	timeout = typeof timeout !== 'undefined' ? timeout : 3000;			
	
	// append markup if it doesn't already exist
	if ($('#notification').length < 1) {
		markup = '<div id="notification" class="information"><span>Hello!</span><a class="close" href="#">x</a></div>';
		$('body').append(markup);
	}
	
	// elements
	$notification = $('#notification');
	$notificationSpan = $('#notification span');
	$notificationClose = $('#notification a.close');
	
	// set the message
	$notificationSpan.text(message);
	
	// setup click event
	$notificationClose.click(function (e) {
		e.preventDefault();
		$notification.css('top', '-50px');
	});
	
	// for ie6, scroll to the top first
	if($.browser.msie && $.browser.version < 7){
		$('html').scrollTop(0);
	}
	
	// hide old notification, then show the new notification
	$notification.css('top', '-50px').stop().removeClass().addClass(type).animate({
		top: 0
	}, 500, function() {
		$notification.delay(timeout).animate({
			top: '-50px'
		}, 500);
	});
}