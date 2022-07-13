-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end


local pad = {}
        pad.x = 0
        pad.y = 0
        pad.largeur = 80
        pad.hauteur = 20
local balle = {}
        balle.x = 0
        balle.y = 0
        balle.vx = 0
        balle.vy = 0
        balle.rayon = 10
        balle.colle = false
local brique = {}
local niveau = {}
function demarre_jeu()
    balle.colle = true

    niveau = {}
    local l, c
    for l = 1, 6 do 
        niveau[l] = {}
        for c= 1, 15 do 
            niveau[l][c] = 1
        end
    end

end

function love.load()
  largeur_ecran = love.graphics.getWidth()
  hauteur_ecran = love.graphics.getHeight()

    brique.hauteur = 25
    brique.largeur = largeur_ecran/15

    pad.y = hauteur_ecran - (pad.hauteur/2)
    demarre_jeu()
end

function love.update(dt)
    --indexer la raquetteX sur la sourisX 
    pad.x = love.mouse.getX()

    if balle.colle then
        --centrer la balle sur la raquette
        balle.x = pad.x
        balle.y = pad.y-(pad.hauteur/2)-balle.rayon
    else
        --decoller la raquette
        balle.x = balle.x + (balle.vx*dt)
        balle.y = balle.y + (balle.vy*dt)
    end
    --collision briques
    local colonne = math.floor(balle.x / brique.largeur)+1
    local ligne = math.floor(balle.y / brique.hauteur)+1
    if ligne >=1 and ligne <= #niveau and colonne >= 1 and colonne <= 15 then
        if niveau[ligne][colonne] == 1 then
            balle.vy = 0-balle.vy
            niveau[ligne][colonne] = 0
        end
    end
    --collision murs
    if balle.x > largeur_ecran then
        balle.vx = 0 - balle.vx 
        balle.x = largeur_ecran
    end
    if balle.x < 0 then 
        balle.vx = 0 - balle.vx 
        balle.x = 0
    end
    if balle.y < 0 then 
        balle.vy = 0 - balle.vy 
        balle.y = 0
    end
    if balle.y > hauteur_ecran then 
        --balle perdue
        demarre_jeu()
    end
    --collision avec la raquette
    local posCollisionPad = pad.y-balle.rayon-(pad.hauteur/2)
    if balle.y > posCollisionPad then
        local posCollisionPadX = math.abs(pad.x - balle.x)
        if posCollisionPadX < pad.largeur/2 then 
            balle.vy = 0 - balle.vy 
            balle.y = posCollisionPad
        end
    end
end

function love.draw()
    local x, y = 0, 0

    local l, c 
    for l=1, 6 do 
        for c= 1, 15 do
            if niveau[l][c] == 1 then 
            love.graphics.rectangle("fill", x+1, y+1, brique.largeur-2, brique.hauteur-2)
            end
            x = x + brique.largeur
        end
        y = y + brique.hauteur
        x = 0
    end

    love.graphics.rectangle("fill", pad.x - (pad.largeur/2), pad.y -(pad.hauteur/2), pad.largeur, pad.hauteur)
    love.graphics.circle("fill", balle.x, balle.y, balle.rayon)
end

function love.mousepressed(x,n,y)
    if balle.colle == true then 
        balle.colle = false
        balle.vx = 200
        balle.vy = -200
    end
end

function love.keypressed(key)
  print(key)
end