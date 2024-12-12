import glacier/should
import pages/set_name.{set_name_page, waiting}

pub fn set_name_page_test() {
  set_name_page()
  |> should.equal(
    "<div id=\"page\" class=\"hero bg-base-100 min-h-full\"><h1 class=\"text-5xl font-bold mt-4\">Tic-Tac-Toe</h1><div class=\"hero-content text-center absolute top-1/2 -translate-y-1/2\"><div class=\"max-w-md\"><div><p class=\"font-bold text-3xl mb-3\">What&#39;s your name?</p><div id=\"pageInputs\"><form ws-send id=\"set-name-form\"><div class=\"join\"><input name=\"name\" placeholder=\"Your name\" class=\"input input-bordered join-item\"><button class=\"btn join-item bg-secondary text-secondary-content hover:bg-accent\"><svg xmlns=\"http://www.w3.org/2000/svg\" preserveAspectRatio=\"xMidYMid meet\" viewBox=\"0 0 5120.000000 5120.000000\" height=\"5120.000000pt\" width=\"5120.000000pt\" version=\"1.0\" xmlns=\"http://www.w3.org/2000/svg\" class=\"w-5 h-5 fill-current\"><g xmlns=\"http://www.w3.org/2000/svg\" stroke=\"none\" fill=\"#000000\" transform=\"translate(0.000000,5120.000000) scale(0.100000,-0.100000)\"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M40510 40544 c-466 -30 -793 -91 -1170 -219 -491 -167 -908 -404 -1335 -756 -56 -46 -4208 -4189 -9537 -9517 l-9437 -9436 -2850 2851 c-1675 1676 -2901 2894 -2973 2955 -648 550 -1405 876 -2253 970 -76 8 -239 13 -445 13 -363 -1 -506 -15 -822 -79 -1419 -291 -2590 -1321 -3062 -2694 -98 -287 -164 -582 -202 -907 -22 -185 -25 -661 -6 -835 73 -650 263 -1220 583 -1748 142 -235 311 -456 511 -672 219 -236 8753 -8757 8853 -8839 284 -234 553 -411 850 -556 801 -392 1694 -512 2583 -350 697 128 1390 462 1927 928 61 52 5049 5036 11086 11074 9300 9301 10993 10999 11083 11113 775 975 1071 2223 815 3435 -162 768 -530 1457 -1079 2019 -361 368 -709 621 -1155 837 -446 216 -896 344 -1385 393 -147 15 -479 27 -580 20z\"></path></g></svg></button></div></form><div id=\"waiting\"></div></div></div></div></div></div>",
  )
}

pub fn waiting_test() {
  waiting()
  |> should.equal(
    "<div id=\"waiting\"><p class=\"text-sm mt-1 text-info\">Waiting for the other player...</p></div>",
  )
}
