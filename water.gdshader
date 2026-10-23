shader_type canvas_item;

// Capture propre de l'écran pour le Pixel Art
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

// Variables globales transmises par le script
uniform float hauteur_eau_global = 0.0;

group_uniforms Aspect_Kingdom;
uniform vec4 couleur_eau : source_color = vec4(0.05, 0.1, 0.2, 1.0); // Fond de l'eau sombre et opaque
uniform float force_reflet : hint_range(0.0, 1.0) = 0.6;             // Visibilité du reflet sur l'eau
uniform float vitesse = 0.05;
uniform float force_vague = 0.02;

uniform sampler2D noise_texture : repeat_enable;
uniform sampler2D noise_texture2 : repeat_enable;

// Variables passerelles entre vertex et fragment
varying float coord_y_ecran;
varying float eau_y_ecran;

void vertex() {
    // Calcul de la position de l'eau par rapport à l'écran
    vec4 position_clip = SCREEN_MATRIX * CANVAS_MATRIX * MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0);
    coord_y_ecran = position_clip.y;
    
    vec4 position_eau_clip = SCREEN_MATRIX * CANVAS_MATRIX * vec4(0.0, hauteur_eau_global, 0.0, 1.0);
    eau_y_ecran = position_eau_clip.y;
}

void fragment() {
    // Ligne de flottaison en Screen UV (0.0 à 1.0)
    float ligne = eau_y_ecran * 0.5 + 0.5;
    
    if (SCREEN_UV.y > ligne) {
        // 1. Vagues horizontales
        float n1 = texture(noise_texture, vec2(UV.x + TIME * vitesse, UV.y)).r * force_vague;
        n1 -= (force_vague * 0.5);
        
        // 2. Lignes de texture à la Kingdom
        float n2 = texture(noise_texture2, UV * vec2(0.5, 4.0) + vec2(n1, 0.0)).r;
        float lignes_eau = (n2 < 0.35) ? 1.0 : 0.0;
        
        // 3. Miroir inversé parfait calé sur la berge
        vec2 uv_reflet = vec2(SCREEN_UV.x + n1, ligne - (SCREEN_UV.y - ligne));
        vec4 pixel_reflet = texture(SCREEN_TEXTURE, uv_reflet);
        
        // CORRECTION : On mélange le reflet directement sur la couleur opaque de l'eau.
        // Cela écrase complètement le vrai fond du jeu situé derrière le ColorRect.
        vec4 mix_miroir = mix(couleur_eau, pixel_reflet, force_reflet);
        
        // 4. Ajout des petites lignes de vagues claires
        COLOR = mix(mix_miroir, vec4(lignes_eau), 0.15);
        
        // On force l'opacité totale du rectangle d'eau
        COLOR.a = 1.0; 
    } else {
        // Rend le haut du ColorRect invisible au-dessus de la berge
        discard;
    }
}
