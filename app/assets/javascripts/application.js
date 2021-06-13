// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//


//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require jquery_ujs
//= require activestorage
//= require turbolinks
//= require_tree .

/*global $*/
$(document).on('turbolinks:load', function() {
  $(".full-screen-o").slick({
    centerMode: true, // スライドを中心に表示して部分的に前後のスライドが見えるように設定（奇数番号のスライドに使用）
    centerPadding: '5%', // センターモード時のサイドパディング。見切れるスライドの幅。’px’または’％’。
    dots: true, // ドットインジケーターの表示
    autoplay: true, // 自動再生を設定
    autoplaySpeed: 3000, // 自動再生のスピード（ミリ秒単位）
    speed: 1000, // スライド/フェードアニメーションの速度を設定
    infinite: true // スライドのループを有効にするか
  });
});


// $(document).on('turbolinks:load',function() {
// 	$(window).on('load scroll', function() {
// 		var scrollPos = $(this).scrollTop();
// 		if ( scrollPos > 80 ) {
// 			$('header').addClass('is-animation');
// 			$('#navbar-content-center').removeClass('center-nav-title');
// 			$('#navbar').removeClass('nav-list');
// 		} else {
// 			$('header').removeClass('is-animation');
// 			$('#navbar-content-center').addClass('center-nav-title');
// 			$('#navbar').addClass('nav-list');
// 		}
// 	});
// });