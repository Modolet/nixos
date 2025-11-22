{ config, ... }:
{
  programs.niri.settings.animations = {
    window-open = {
      kind.spring = {
        damping-ratio = 0.7;
        stiffness = 300;
        epsilon = 0.001;
      };
      custom-shader =
        # glsl
        ''
          // Example: fill the current geometry with a solid vertical gradient and
          // gradually make opaque.
          vec4 solid_gradient(vec3 coords_geo, vec3 size_geo) {
              vec4 color = vec4(0.0);

              // Paint only the area inside the current geometry.
              if (0.0 <= coords_geo.x && coords_geo.x <= 1.0
                      && 0.0 <= coords_geo.y && coords_geo.y <= 1.0)
              {
                  vec4 from = vec4(1.0, 0.0, 0.0, 1.0);
                  vec4 to = vec4(0.0, 1.0, 0.0, 1.0);
                  color = mix(from, to, coords_geo.y);
              }

              // Make it opaque.
              color *= niri_clamped_progress;

              return color;
          }

          // Example: gradually scale up and make opaque, equivalent to the default
          // opening animation.
          vec4 default_open(vec3 coords_geo, vec3 size_geo) {
              // Scale up the window.
              float scale = max(0.0, (niri_progress / 2.0 + 0.5));
              coords_geo = vec3((coords_geo.xy - vec2(0.5)) / scale + vec2(0.5), 1.0);

              // Get color from the window texture.
              vec3 coords_tex = niri_geo_to_tex * coords_geo;
              vec4 color = texture2D(niri_tex, coords_tex.st);

              // Make the window opaque.
              color *= niri_clamped_progress;

              return color;
          }

          // Example: show the window as an expanding circle.
          vec4 expanding_circle(vec3 coords_geo, vec3 size_geo) {
              vec4 color = vec4(0.0);

              // The distance from the center of the window.
              float dist = distance(coords_geo.xy, vec2(0.5));

              // An expanding circle with radius that increases over time.
              float radius = niri_progress / 2.0;
              if (dist < radius)
              {
                  // Get color from the window texture.
                  vec3 coords_tex = niri_geo_to_tex * coords_geo;
                  color = texture2D(niri_tex, coords_tex.st);

                  // Fade in near the edge.
                  float edge_fade = 1.0 - (dist / radius);
                  edge_fade = clamp(edge_fade, 0.0, 1.0);

                  color *= edge_fade;
              }

              return color;
          }

          // We use the expanding circle for this animation.
          return expanding_circle(coords_geo, size_geo);
        '';
    };
    window-close = {
      kind.spring = {
        damping-ratio = 1.0;
        stiffness = 800;
        epsilon = 0.0001;
      };
      custom-shader =
        # glsl
        ''
          // Fire effect for window closing animation
          vec4 fire_effect(vec3 coords_geo, vec3 size_geo) {
              vec4 color = vec4(0.0);

              // Paint only the area inside the current geometry.
              if (0.0 <= coords_geo.x && coords_geo.x <= 1.0
                      && 0.0 <= coords_geo.y && coords_geo.y <= 1.0)
              {
                  // Get the original window color
                  vec3 coords_tex = niri_geo_to_tex * coords_geo;
                  vec4 original_color = texture2D(niri_tex, coords_tex.st);

                  // Create fire colors
                  vec4 fire_red = vec4(1.0, 0.0, 0.0, 1.0);
                  vec4 fire_orange = vec4(1.0, 0.5, 0.0, 1.0);
                  vec4 fire_yellow = vec4(1.0, 1.0, 0.0, 1.0);

                  float progress = niri_progress;
                  float fire_height = (1.0 - progress) * 2.0;

                  if (coords_geo.y < fire_height) {
                      float height_factor = 1.0 - (coords_geo.y / fire_height);

                      // Mix original window color with fire effect
                      if (height_factor > 0.7) {
                          color = mix(original_color, fire_yellow, progress);
                      } else if (height_factor > 0.3) {
                          color = mix(original_color, fire_orange, progress);
                      } else {
                          color = mix(original_color, fire_red, progress);
                      }

                      // Add flickering effect
                      float flicker = sin(coords_geo.x * 50.0 + progress * 30.0) * 0.1 + 0.9;
                      color *= flicker;
                  } else {
                      // Original window color outside fire area
                      color = original_color;
                  }

                  // Fade out overall
                  color *= (1.0 - niri_clamped_progress);
              }

              return color;
          }

          return fire_effect(coords_geo, size_geo);
        '';
    };
    workspace-switch = {
      kind.spring = {
        damping-ratio = 1.0;
        stiffness = 1000;
        epsilon = 0.0001;
      };
    };
    config-change-open = {
      kind.spring = {
        damping-ratio = 1.0;
        stiffness = 800;
        epsilon = 0.0001;
      };
    };
    config-change-close = {
      kind.spring = {
        damping-ratio = 1.0;
        stiffness = 800;
        epsilon = 0.0001;
      };
    };
    horizontal-view-movement = {
      kind.spring = {
        damping-ratio = 1.0;
        stiffness = 600;
        epsilon = 0.001;
      };
    };
    window-movement = {
      kind.spring = {
        damping-ratio = 1.0;
        stiffness = 600;
        epsilon = 0.001;
      };
    };
  };
}