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
    slidesToShow: 3, // 一度に表示する枚数
    slidesToScroll: 1, // スクロールする画像の枚数
  });


  //投稿画像のスライダー
  $('#slider').slick({
    dots: true, //スライドの下にドットのナビゲーションを表示
    autoplay: false, //自動再生しない
    slidesToShow: 1, // 一度に表示する枚数
  });


  // read more...の表示
  var $text = $('.show-caption, .ranking-caption'); // 対象のテキスト
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
  });


  // 画像プレビュー
  $('#post_post_images_images').on('change', function (e) { // 中身が変更されたら(changeというイベントが発生したら)、function(e)を実行
                                                            // eは、post_post_images_imagesのデータが入っている状態

      if(e.target.files.length > 5){ // 5枚以上選択した場合
        alert('投稿できるのは5枚までです。');
        $('#post_post_images_images').val = ""; // 選択したファイルをリセットする

        for( let i = 0; i < 5; i++) {         // 以前の画像のプレビューが残っていた場合は
          $(`#preview_${i}`).attr('src', ""); // まだ画像選択できていると勘違いを誘発するため初期化
        }

      }else{
        let reader = new Array(5);

        for( let i = 0; i < 5; i++) {
          $(`#preview_${i}`).attr('src', ""); // 画像選択を2回した時、1回目より数が少ないと画面上に残るので初期化
        }

        for(let i = 0; i < e.target.files.length; i++) {
          reader[i] = new FileReader(); // 変数reader関数を定義し、FileReaderを定義してファイルを読めるようにする
          reader[i].onload = finisher(i,e); // reader.onloadでファイルの読み込みが可能にし、再び別の無名関数の内容を実行する
                                            // iは数字、eはidがpost_post_images_imagesになっている場所からデータを引き出している
          reader[i].readAsDataURL(e.target.files[i]); // 『ファイルの読み込み』と『ファイルを参照するためのURL生成』を行い、
                                                      // ファイルを配列（複数）で受け取っている
                                                      // onloadは読み込みが発生しないと動かないためこの記述が必要

          // onloadは別関数で準備しないとfor文内では使用できないので、関数を準備。
          function finisher(i,e){
            return function(e){
            $(`#preview_${i}`).attr('src', e.target.result); // idがpreview_{数字}になっているところに、画像データの取得結果を反映させるよう設定
            }                                                // imgタグはsrcの指定で画像を読み込むため、srcの部分にe = post_post_images_imagesのデータを反映させている
          }
        }
     }
  });
});
