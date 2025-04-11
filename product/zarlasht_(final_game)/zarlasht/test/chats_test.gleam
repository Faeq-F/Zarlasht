import app/pages/chat.{send_message_section}
import glacier/should
import gleam/int
import lustre/element

pub fn messaging_section1_test() {
  send_message_section(1)
  |> element.to_string
  |> should.equal(
    "<div id=\"send_message_section\" class=\"!mt-2 !h-[15%] flex w-full flex-col overflow-hidden border-neutral-300 bg-white/50 text-neutral-600 has-[p:focus]:outline-2 has-[p:focus]:outline-offset-2 has-[p:focus]:outline-black dark:border-neutral-700 dark:bg-neutral-900 dark:text-neutral-300 dark:has-[p:focus]:outline-white rounded-xl !border !border-neutral-500 \"><div class=\"p-2\"><p id=\"promptLabel\" class=\"pb-1 pl-2 text-sm font-text font-bold text-neutral-600 opacity-60 dark:text-neutral-300\">Enter your message below</p><form ws-send id=\"send_message_1\"><textarea name=\"messageText\" class=\"font-text scroll-on max-h-8 h-8 w-full overflow-y-auto px-2 py-1 !outline-none resize-none\"></textarea><button class=\"font-text h-[2rem] !mr-1 text-white !ml-auto flex items-center gap-2 whitespace-nowrap hover:bg-black bg-black/80 !px-4 !py-2 text-center !text-sm font-medium tracking-wide text-neutral-100 transition focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-black active:opacity-100 active:outline-offset-0 disabled:cursor-not-allowed disabled:opacity-75 dark:bg-white dark:text-black dark:focus-visible:outline-white rounded-lg\">Send<svg xmlns=\"http://www.w3.org/2000/svg\" stroke-linejoin=\"round\" stroke-linecap=\"round\" stroke-width=\"2\" stroke=\"currentColor\" fill=\"none\" viewBox=\"0 0 24 24\" height=\"24\" width=\"24\" class=\"w-4\"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M3.714 3.048a.498.498 0 0 0-.683.627l2.843 7.627a2 2 0 0 1 0 1.396l-2.842 7.627a.498.498 0 0 0 .682.627l18-8.5a.5.5 0 0 0 0-.904z\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M6 12h16\"></path></svg></button></form></div></div>",
  )
}

pub fn messaging_section2_test() {
  send_message_section(2)
  |> element.to_string
  |> should.equal(
    "<div id=\"send_message_section\" class=\"!mt-2 !h-[15%] flex w-full flex-col overflow-hidden border-neutral-300 bg-white/50 text-neutral-600 has-[p:focus]:outline-2 has-[p:focus]:outline-offset-2 has-[p:focus]:outline-black dark:border-neutral-700 dark:bg-neutral-900 dark:text-neutral-300 dark:has-[p:focus]:outline-white rounded-xl !border !border-neutral-500 \"><div class=\"p-2\"><p id=\"promptLabel\" class=\"pb-1 pl-2 text-sm font-text font-bold text-neutral-600 opacity-60 dark:text-neutral-300\">Enter your message below</p><form ws-send id=\"send_message_2\"><textarea name=\"messageText\" class=\"font-text scroll-on max-h-8 h-8 w-full overflow-y-auto px-2 py-1 !outline-none resize-none\"></textarea><button class=\"font-text h-[2rem] !mr-1 text-white !ml-auto flex items-center gap-2 whitespace-nowrap hover:bg-black bg-black/80 !px-4 !py-2 text-center !text-sm font-medium tracking-wide text-neutral-100 transition focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-black active:opacity-100 active:outline-offset-0 disabled:cursor-not-allowed disabled:opacity-75 dark:bg-white dark:text-black dark:focus-visible:outline-white rounded-lg\">Send<svg xmlns=\"http://www.w3.org/2000/svg\" stroke-linejoin=\"round\" stroke-linecap=\"round\" stroke-width=\"2\" stroke=\"currentColor\" fill=\"none\" viewBox=\"0 0 24 24\" height=\"24\" width=\"24\" class=\"w-4\"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M3.714 3.048a.498.498 0 0 0-.683.627l2.843 7.627a2 2 0 0 1 0 1.396l-2.842 7.627a.498.498 0 0 0 .682.627l18-8.5a.5.5 0 0 0 0-.904z\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M6 12h16\"></path></svg></button></form></div></div>",
  )
}

pub fn random_messaging_section_test() {
  let random = int.random(1000)
  send_message_section(random)
  |> element.to_string
  |> should.equal(
    "<div id=\"send_message_section\" class=\"!mt-2 !h-[15%] flex w-full flex-col overflow-hidden border-neutral-300 bg-white/50 text-neutral-600 has-[p:focus]:outline-2 has-[p:focus]:outline-offset-2 has-[p:focus]:outline-black dark:border-neutral-700 dark:bg-neutral-900 dark:text-neutral-300 dark:has-[p:focus]:outline-white rounded-xl !border !border-neutral-500 \"><div class=\"p-2\"><p id=\"promptLabel\" class=\"pb-1 pl-2 text-sm font-text font-bold text-neutral-600 opacity-60 dark:text-neutral-300\">Enter your message below</p><form ws-send id=\"send_message_193\"><textarea name=\"messageText\" class=\"font-text scroll-on max-h-8 h-8 w-full overflow-y-auto px-2 py-1 !outline-none resize-none\"></textarea><button class=\"font-text h-[2rem] !mr-1 text-white !ml-auto flex items-center gap-2 whitespace-nowrap hover:bg-black bg-black/80 !px-4 !py-2 text-center !text-sm font-medium tracking-wide text-neutral-100 transition focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-black active:opacity-100 active:outline-offset-0 disabled:cursor-not-allowed disabled:opacity-75 dark:bg-white dark:text-black dark:focus-visible:outline-white rounded-lg\">Send<svg xmlns=\"http://www.w3.org/2000/svg\" stroke-linejoin=\"round\" stroke-linecap=\"round\" stroke-width=\"2\" stroke=\"currentColor\" fill=\"none\" viewBox=\"0 0 24 24\" height=\"24\" width=\"24\" class=\"w-4\"><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M3.714 3.048a.498.498 0 0 0-.683.627l2.843 7.627a2 2 0 0 1 0 1.396l-2.842 7.627a.498.498 0 0 0 .682.627l18-8.5a.5.5 0 0 0 0-.904z\"></path><path xmlns=\"http://www.w3.org/2000/svg\" d=\"M6 12h16\"></path></svg></button></form></div></div>",
  )
}
