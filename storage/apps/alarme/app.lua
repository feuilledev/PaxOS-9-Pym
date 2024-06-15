local tNow

-- récupération de la fenetre
local win = gui:window()
local winAlarme

-- liste Alarme
listAlarme ={
    {"lever 1", "7:30", true}, 
    {"lever 2", "8:30", false},
    {"lever 3", "9:30", true}
}

-- Définition des couleurs de l'horloge
local BACKGROUND_COLOR = COLOR_WHITE
local couleur_clock = COLOR_DARK
local couleur_aiguille_sec = COLOR_RED

function int(x)
    return math.floor(x)
end

-- renvoi une string au format HH:MM:SS
function convert_to_time(h, min, sec)
    local strHeure = h
    -- Gestion Heure
    if tonumber(h) < 10 then
        if tonumber(h) == nil then
            strHeure = "00"
        else
            strHeure = "0" .. h
        end
    end

    local strMin = min
    -- Gestion Minute
    if tonumber(min) < 10 then
        if tonumber(min) == nil then
            strMin = "00"
        else
            strMin = "0" .. min
        end
    end

    local strSec = sec
    -- Gestion Seconde
    if tonumber(sec) < 10 then
        if tonumber(sec) == nil then
            strSec = "00"
        else
            strSec = "0" .. sec
        end
    end

    return strHeure .. ":" .. strMin .. ":" .. strSec
end -- convert_to_time


-- Fonction d'affichage de l'heure en digital, et en mode horloge
function afficheHeure()

    -- recupere l'heure
    tNow = time:get("h,mi,s")

    local heure = tNow[1]
    local minute = tNow[2]
    local seconde = tNow[3]

    local now = convert_to_time(heure, minute, seconde) --= table.concat(tNow, ":")
    heure_label:setText(now)

    idRefreshClock = time:setTimeout(afficheHeure, 1000)
end -- afficheHeure

-- Affichage initiale de l'écran
function init()

    -- Titre 
    local title = gui:label(win, 35, 10, 144, 28)
    title:setFontSize(24)
    title:setText("Alarme")

    -- Label de l'heure courante
    heure_label = gui:label(win, 0, 50, 320, 30)
    heure_label:setHorizontalAlignment(CENTER_ALIGNMENT)

    -- Liste des alarmes
    lstAlarme = gui:vlist(win, 70, 110, 250, 280)

    for i, value in pairs(listAlarme) do
        local case = gui:box(lstAlarme, 0, 0, 250, 25)

        local heure = gui:label(case, 0, 0, 100, 18)
        heure:setText(value[2])
        heure:setFontSize(16)

        local nom = gui:label(case, 100, 0, 100, 18)
        nom:setText(value[1])
        nom:setFontSize(16)

        local btnToggleAlarme = gui:switch(case, 200, 0, 18, 18)
        if value[3] then
            btnToggleAlarme:setState(true)
            heure:setTextColor(COLOR_BLACK)
            nom:setTextColor(COLOR_BLACK)
        else
            btnToggleAlarme:setState(false)
            heure:setTextColor(COLOR_GREY)
            nom:setTextColor(COLOR_GREY)

        end 
        btnToggleAlarme:onClick(function () fnToggleAlarme(btnToggleAlarme, heure, nom) end)

        --case:onClick(function() openContact(value) end)
    end

    -- bouton +
    local add = gui:box(win, 250, 410, 40, 40)
    add:setMainColor(COLOR_DARK)
    add:setRadius(20)
    local icon_plus = gui:image(add, "plus.png", 14, 14, 12, 12, COLOR_DARK)
    --add:onClick(newContact)

    -- bouton de test
    testAlarme = gui:button(win, 35, 350, 250, 38)
    testAlarme:setText("Test")
    testAlarme:onClick(
        function()
            print("btn Cliqué")
            closeAlarme()
        end
    )

    gui:setWindow(win)

end -- init


function fnToggleAlarme(btn, lblHeure, lblNom)
        if btn:getState() then
            lblHeure:setTextColor(COLOR_BLACK)
            lblNom:setTextColor(COLOR_BLACK)
        else
            lblHeure:setTextColor(COLOR_GREY)
            lblNom:setTextColor(COLOR_GREY)
        end
end




-- Fonction pour fermer la fenetre de l'application 
-- lance le timer si l'alarme est active
function closeAlarme()
        -- get the time diff
        local heureDiff = 1000 *10
        time:setTimeout( ringAlarme, heureDiff)
        
end -- function closeAlarme


-- Fonction de lancement de l'alarme
function ringAlarme()
    print("ringAlarme")
    hardware:setVibrator(true);

    winAlarme = gui:window()
    gui:setWindow(winAlarme)

    -- time:removeTimeout(idRefreshClock)

    local x = 10
    local y = 10
    local width = 300
    local height = 200
    local radius = 5

    popupAlarme = gui:canvas(winAlarme, x, y, width, height)
    popupAlarme:fillRect(0, 0, width, height, COLOR_WHITE)
    popupAlarme:drawRoundRect(0, 0, width, height, 5, COLOR_RED);

    popupAlarme:drawTextCentered(5, 5, "ALARME !", COLOR_BACK, true, true)

    local close = gui:button(popupAlarme, 30, height-38-10, width-(30*2), 38);
    close:setText("Fermer")
    close:onClick(
        function()
            time:setTimeout(
                function()
                    -- réactivation de la fenetre principale
                    gui:setWindow(win)
                    -- réactiviation de l'horloge
                    -- idRefreshClock = time:setTimeout(afficheHeure, 1000)
                    -- on ferme la fenetre
                    gui:del(popupAlarme) 
                end,
                0
            )
        end
    )

end

function run()
    init()
    afficheHeure()
end --run

local tNow
local win
local heure_label
local clock
local offsetAngle = 270

-- VERRUE  VIRER
local heure = 6 --tNow[0]
local minute = 7 --tNow[1]
local seconde = 9 --tNow[2]

local oldCoordHeure = {}
local oldCoordMinute = {}
local oldCoordSeconde = {}

local toBeRefreshed = false

local BACKGROUND_COLOR = COLOR_WHITE

function int(x)
    return math.floor(x)
end


-- dessine l'horloge
function drawClock()

    centreX = int (win:getWidth() * 0.5)
    centreY = centreX --int (win:getHeight() * 0.5)
    border = 15
    radius = int(centreX - border *2)

    -- couleir d'affichage du cadre
    couleur_clock = COLOR_DARK

    local size_major = 10
    local size_minor = 2
    local espacement = 5

    -- draw clock circle
    clock = gui:canvas(win, 0, 15, int(win:getWidth()), int(win:getWidth()))
    clock:fillRect(0,0,int(win:getWidth()), int(win:getWidth()),BACKGROUND_COLOR)
--    drawRect_canvas:drawRect(5, 5, 15, 15, COLOR_WARNING)
    --drawCircle_canvas:setBackgroundColor(COLOR_WHITE)
    clock:drawCircle(centreX, centreY, radius, couleur_clock)


    -- loop pour les 5 min
    for i=0,11 do
        -- convert angle in radian
        degres = math.rad(i*30 + offsetAngle)
        
        clock:drawLine(
            int(centreX + math.cos(degres) * (radius - (size_major + espacement))),
            int(centreY + math.sin(degres) * (radius - (size_major + espacement))),
            int(centreX + math.cos(degres) * (radius - espacement)),
            int(centreY + math.sin(degres) * (radius -  espacement)),
            couleur_clock
        )
    end -- loop
    -- loop pour les 1 min
    for i=0,59 do
        -- convert angle in radian
        degres = math.rad(i*6+ offsetAngle)
        
        clock:drawLine(
            int(centreX + math.cos(degres) * (radius - (size_minor + espacement))),
            int(centreY + math.sin(degres) * (radius - (size_minor + espacement))),
            int(centreX + math.cos(degres) * (radius - espacement)),
            int(centreY + math.sin(degres) * (radius -  espacement)),
            couleur_clock
        )
    end -- loop

end -- drawClock


function convert_to_time (h, min, sec)

    
    local strHeure = h
    -- Gestion Heure
    if tonumber(h) < 10 then
        if tonumber(h) == nil then
            strHeure = "00"    
        else
            strHeure = "0"..h
        end
    end
    
    local strMin = min
    -- Gestion Minute
    if tonumber(min) < 10 then
        if tonumber(min) == nil then
            strMin = "00"    
        else
            strMin = "0"..min
        end
    end

    local strSec = sec
    -- Gestion Seconde
    if tonumber(sec) < 10 then
        if tonumber(sec) == nil then
            strSec = "00"    
        else
            strSec = "0"..sec
        end
    end

    return strHeure .. ":" .. strMin .. ":" .. strSec
end -- convert_to_time


-- Recopie une structure dans une autre
function copyStruct (source, dest)

    print("copyStruct ".. tostring(pairs(source)))
    for i in pairs(source) do
        print("dest["..i.."]=".. source[i])
        dest[i] = source[i]
    end

--    oldCoordHeure = {
--        orig_x = coordHeure.orig_x,
--        orig_y = coordHeure.orig_y,
--        dest_x = coordHeure.dest_x,
--        dest_y = coordHeure.dest_y
--    }
end -- function copyStruct


-- Fonction d'affichage de l'heure en digital, et en mode horloge
function afficheHeure ()

    -- recupere l'heure
    tNow = time:get("h,mi,s")
--    tNow = {heure,minute,seconde}

    local now = convert_to_time(heure, minute, seconde) --= table.concat(tNow, ":")
    heure_label:setText(now)

    -- Efface les anciennes aiguilles
    -- Si c'est le 1er affichage, alors il n'y a rien à effacer...
    if toBeRefreshed then
        clock:drawLine(oldCoordHeure.orig_x,oldCoordHeure.orig_y, oldCoordHeure.dest_x,oldCoordHeure.dest_y,BACKGROUND_COLOR)
        clock:drawLine(oldCoordMinute.orig_x,oldCoordMinute.orig_y, oldCoordMinute.dest_x,oldCoordMinute.dest_y,BACKGROUND_COLOR)
        clock:drawLine(oldCoordSeconde.orig_x,oldCoordSeconde.orig_y, oldCoordSeconde.dest_x,oldCoordSeconde.dest_y,BACKGROUND_COLOR)
    end
    toBeRefreshed = true

    -- affichage aiguille Heure

    -- calcul de l'angle pour une heure (avec la variation des minute)
    -- une cadran = 12 h de 60 min
    local nbMinute = heure * 60 + minute
    local radian = math.rad (nbMinute * 360 / (12*60) + offsetAngle)

    local coordHeure = {
        orig_x = centreX,
        orig_y = centreY,
        dest_x = int (centreX + math.cos(radian) * radius * 0.5),
        dest_y = int (centreY + math.sin(radian) * radius * 0.5)
    }
    

    clock:drawLine(coordHeure.orig_x,coordHeure.orig_y, coordHeure.dest_x,coordHeure.dest_y,COLOR_DARK)
    
    -- Sauvegarde de la position de l'aiguille pour pouvoir l'effacer au prochaine rafraichissement
    copyStruct(coordHeure, oldCoordHeure)

--    oldCoordHeure = {
--        orig_x = coordHeure.orig_x,
--        orig_y = coordHeure.orig_y,
--        dest_x = coordHeure.dest_x,
--        dest_y = coordHeure.dest_y
--    }

    -- affichage aiguille Minute
    radian = math.rad (minute * 360 / 60 +offsetAngle)

    local coordMinute = {
        orig_x = centreX,
        orig_y = centreY,
        dest_x = int(centreX + math.cos(radian) * radius * 0.75),
        dest_y = int(centreY + math.sin(radian) * radius * 0.75)
    }

    clock:drawLine(coordMinute.orig_x,coordMinute.orig_y, coordMinute.dest_x,coordMinute.dest_y,COLOR_DARK)

    -- Sauvegarde de la position de l'aiguille pour pouvoir l'effacer au prochaine rafraichissement
    copyStruct(coordMinute, oldCoordMinute)

--    oldCoordMinute = {
--        orig_x = coordMinute.orig_x,
--        orig_y = coordMinute.orig_y,
--        dest_x = coordMinute.dest_x,
--        dest_y = coordMinute.dest_y
--    }

    -- affichage aiguille Seconde
    radian = math.rad (seconde * 360 / 60 +offsetAngle)

    local coordSeconde = {
        orig_x = centreX,
        orig_y = centreY,
        dest_x = int(centreX + math.cos(radian) * radius * 0.75),
        dest_y = int(centreY + math.sin(radian) * radius * 0.75)
    }

    clock:drawLine(coordSeconde.orig_x,coordSeconde.orig_y, coordSeconde.dest_x,coordSeconde.dest_y, COLOR_ERROR)
    -- Sauvegarde de la position de l'aiguille pour pouvoir l'effacer au prochaine rafraichissement
    copyStruct(coordSeconde, oldCoordSeconde)

    --    oldCoordSeconde = {
--        orig_x = coordSeconde.orig_x,
--        orig_y = coordSeconde.orig_y,
--        dest_x = coordSeconde.dest_x,
--        dest_y = coordSeconde.dest_y
--    }

    -- set timer to refresh in 1 sec
    time:setTimeout(afficheHeure, 1000)

    -- incrément manuel des secondes 
    seconde = seconde +1


end -- afficheHeure


function init()

    win = gui:window()


    heure_label = gui:label(win, 0, 0, 320, 15)
    heure_label:setHorizontalAlignment(CENTER_ALIGNMENT)
    heure_label:setFontSize(15)

    --drawClock()

    gui:setWindow(win)


end -- init

function run()

    init()

    drawClock()

    afficheHeure()


end --run