script_name("sky_carti_1kkk")
script_author("season")

-- ПОДКЛЮЧАЕМ ЕБУЧИЮ БИБЛЕОТЕКУ СУКА ТВОЮ МА ytreckords
require 'lib.moonloader' 
local samp = require 'samp.events'
local vk = require 'vkeys'

local audio = nil
local play = false
local vol = 1.0
local track = 1

-- треки (если че просто закинь файлы сюда) ДЛЯ ЕБАЧЕЙ ПИШУ: ТРЕК sky.mp3 ЗАКИНЬ В ЕБУЧИЮ ПАПКУ moonloader И СУКА ДАЛЬШЕ ТАК ДЕЛАЕШЬ ЧТОБЫ НАЗВАНИЯ БЫЛИ ИДЕНТИЧНЫМИ или ТЫ СУКА НЕ НАЙДЕШЬ К НИМ ПУТЬ И БУДЕТ КРАШИТЬ ТУПОЙ ТЫ ЕБЛАН (мне грустно щас я слушаю гейскую музыку но я это точно затещу отвечаю... ален ку)
local music = {
    {"Sky", "moonloader\\sky.mp3"},
    {"Magnolia", "moonloader\\magnolia.mp3"},
    {"Fein", "moonloader\\fein.mp3"}
}

-- эффект
local eff = false
local a = 0

function main()
    repeat wait(0) until isSampAvailable()

    sampAddChatMessage("[sky] F5 вкл/выкл | F6/F7 треки | +/- звук", -1)

    while true do
        wait(0)

        if isKeyJustPressed(vk.VK_F5) then
            if play then
                stop()
            else
                start()
            end
        end

        if isKeyJustPressed(vk.VK_F6) then next() end
        if isKeyJustPressed(vk.VK_F7) then back() end

        if isKeyJustPressed(vk.VK_ADD) then volume(0.1) end
        if isKeyJustPressed(vk.VK_SUBTRACT) then volume(-0.1) end

        if eff then draw() end
    end
end

-- чат (если не заработает на f5 в шате пишешь sky вроде все норм геи иии )
function samp.onSendChat(msg)
    if msg:lower() == "sky" then
        if play then stop() else start() end
        return false
    end
end

-- старт
function start()
    if audio then releaseAudioStream(audio) end

    local t = music[track]
    audio = loadAudioStream(t[2])

    if not audio then
        sampAddChatMessage("[sky] не нашел файл", -1)
        return
    end

    setAudioStreamVolume(audio, vol)
    setAudioStreamState(audio, true)

    sampAddChatMessage("[sky] ▶ " .. t[1], -1)

    play = true
    eff = true
end

-- стоп
function stop()
    if audio then
        setAudioStreamState(audio, false)
        releaseAudioStream(audio)
        audio = nil
    end

    sampAddChatMessage("[sky] ⏹ стоп", -1)

    play = false
    eff = false
    a = 0
end

-- след трек
function next()
    track = track + 1
    if track > #music then track = 1 end

    sampAddChatMessage("[sky] трек: " .. music[track][1], -1)

    if play then start() end
end

-- назад
function back()
    track = track - 1
    if track < 1 then track = #music end

    sampAddChatMessage("[sky] трек: " .. music[track][1], -1)

    if play then start() end
end

-- громкость
function volume(v)
    vol = vol + v

    if vol < 0 then vol = 0 end
    if vol > 1 then vol = 1 end

    if audio then
        setAudioStreamVolume(audio, vol)
    end

    sampAddChatMessage(string.format("[sky] звук: %.1f", vol), -1)
end

-- простой эффект ЧУТЬ ТЕМНЕЕ НЕ ОЧКУЙ БРАТАН 
function draw()
    local x, y = getScreenResolution()

    if a < 120 then
        a = a + 2
    end

    renderDrawBox(0, 0, x, y, 0x00000000 + a * 0x01000000)

    local f1 = renderCreateFont("Arial", 20, 5)
    local f2 = renderCreateFont("Arial", 14, 5)
-- ПО ЦЕНРТУ ЭКРАНА БУДЕТ sky mode когда ты нажмешь на F5 ПИДОРР КАК Я НЕНАВИЖУ ВСЕ ЭТО 
    renderFontDrawText(f1, "sky mode", x/2 - 60, y/2 - 15, 0xFFFFFFFF)
    renderFontDrawText(f2, music[track][1], x/2 - 40, y/2 + 10, 0xFFAAAAAA)
end