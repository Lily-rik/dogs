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
//= require jquery.slick
//= require_tree .

/*global $*/
$(document).on('turbolinks:load', function() {

  // 画像スライダー
  $(".full-screen-o").slick({
    arrows: false, // 左右矢印を表示する
    centerMode: true, // スライドを中心に表示して部分的に前後のスライドが見えるように設定（奇数番号のスライドに使用）
    centerPadding: '5%', // センターモード時のサイドパディング。見切れるスライドの幅。’px’または’％’。
    dots: true, // ドットインジケーターの表示
    autoplay: true, // 自動再生を設定
    autoplaySpeed: 3000, // 自動再生のスピード（ミリ秒単位）
    speed: 1000, // スライド/フェードアニメーションの速度を設定
    infinite: true, // スライドのループを有効にするか
    slidesToShow: 3,
    slidesToScroll: 1,
  });

  //投稿画像のスライダー
  $('#slider').slick({
    dots: true, //スライドの下にドットのナビゲーションを表示
    autoplay: false, //自動再生しない
  });

  // read more...の表示
  var $text = $('.show-caption, .ranking-caption');//対象のテキスト
  $text.each((index, el) => {
    var $caption = $(el)
    var $more = $caption.next('.more');//続きを読むボタン
    var lineNum = 2;//表示する行数
    var textHeight = $caption.height();//テキスト全文の高さ
    var lineHeight = parseFloat($caption.css('line-height'));//line-height
    var textNewHeight = lineHeight * lineNum;//指定した行数までのテキストの高さ

    // テキストが表示制限の行数を超えたら発動
    if (textHeight > textNewHeight) {
      $caption.css({
        height: textNewHeight,
        overflow: 'hidden',
      });
      //続きを読むボタンクリックで全文表示
      $more.click(function () {
        $(this).hide();
        $caption.css({
          'height': textHeight,
          'overflow': 'visible',
        });
        return false;//aタグ無効化
      });
    } else {
      // 指定した行数以下のテキストなら続きを読むは表示しない
      $more.hide();
    }
  })


});




// $(function () {
//   var $text = $('.show-caption, .ranking-caption');//対象のテキスト
//   var $more = $('.more');//続きを読むボタン
//   var lineNum = 1;//表示する行数
//   var textHeight = $text.height();//テキスト全文の高さ
//   var lineHeight = parseFloat($text.css('line-height'));//line-height
//   var textNewHeight = lineHeight * lineNum;//指定した行数までのテキストの高さ

//   // テキストが表示制限の行数を超えたら発動
//   if (textHeight > textNewHeight) {
//     $text.css({
//       height: textNewHeight,
//       overflow: 'hidden',
//     });
//     //続きを読むボタンクリックで全文表示
//     $more.click(function () {
//       $(this).hide();
//       $text.css({
//         'height': textHeight,
//         'overflow': 'visible',
//       });
//       return false;//aタグ無効化
//     });
//   } else {
//     // 指定した行数以下のテキストなら続きを読むは表示しない
//     $more.hide();
//   }
// });