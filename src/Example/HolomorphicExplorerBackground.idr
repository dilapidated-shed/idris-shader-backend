module Example.HolomorphicExplorerBackground

import Shader.Source

%default total

tau : Double
tau = 6.28318530717958647692

log_10 : Double
log_10 = 2.30258509299404568402

complex_multiply : SVec 2 -> SVec 2 -> SVec 2
complex_multiply left right =
  vec2
    (x left * x right - y left * y right)
    (x left * y right + y left * x right)

positive_fract : Double -> Double
positive_fract value = value - floorF value

srgb_component : Double -> Double
srgb_component linear_value =
  let value = maxF linear_value 0.0
   in if value <= 0.0031308
         then 12.92 * value
         else 1.055 * powF value (1.0 / 2.4) - 0.055

hcl_to_srgb : Double -> Double -> Double -> SVec 3
hcl_to_srgb hue_degrees chroma lightness =
  let hue = hue_degrees * 3.14159265358979323846 / 180.0
      u_star = chroma * cosF hue
      v_star = chroma * sinF hue
      white_u_prime = 0.19783982482140777
      white_v_prime = 0.46833630293240974
      cie_y =
        if lightness > 8.0
           then powF ((lightness + 16.0) / 116.0) 3.0
           else lightness / 903.2962962962963
      u_prime = u_star / (13.0 * lightness) + white_u_prime
      v_prime = v_star / (13.0 * lightness) + white_v_prime
      cie_x = (9.0 * cie_y * u_prime) / (4.0 * v_prime)
      cie_z = cie_y * (12.0 - 3.0 * u_prime - 20.0 * v_prime) / (4.0 * v_prime)
      linear_r = 3.2404542 * cie_x - 1.5371385 * cie_y - 0.4985314 * cie_z
      linear_g = -0.9692660 * cie_x + 1.8760108 * cie_y + 0.0415560 * cie_z
      linear_b = 0.0556434 * cie_x - 0.2040259 * cie_y + 1.0572252 * cie_z
      red = clampF (srgb_component linear_r) 0.0 1.0
      green = clampF (srgb_component linear_g) 0.0 1.0
      blue = clampF (srgb_component linear_b) 0.0 1.0
   in vec3 red green blue

wegert_color : Double -> Double -> SVec 3
wegert_color phase log_modulus =
  let hue_degrees = 360.0 * positive_fract (phase / tau)
      log_modulus_band = positive_fract (log_modulus / log_10)
      lightness =
        66.0
        + 4.0 * log_modulus_band
        + 3.0 * positive_fract (hue_degrees / 100.0)
   in hcl_to_srgb hue_degrees 45.0 lightness

factor_measure : SVec 2 -> SVec 2 -> SVec 2
factor_measure point factor =
  let delta = vsub point factor
      radius_squared = maxF (dot delta delta) 0.0000000000000001
      phase = atan2F (y delta) (x delta)
      log_modulus = 0.5 * logF radius_squared
   in vec2 phase log_modulus

covering
factor_sum_from :
  SVec 2 -> Double -> SArray 32 (SVec 2) -> Double -> SVec 2 -> SVec 2
factor_sum_from point active factors index state =
  if index < minF active 32.0
     then
       let factor = array_at factors index
           next = vadd state (factor_measure point factor)
        in factor_sum_from point active factors (index + 1.0) next
     else state

covering
factor_sum_32 : SVec 2 -> Double -> SArray 32 (SVec 2) -> SVec 2
factor_sum_32 point active factors =
  factor_sum_from point active factors 0.0 (vec2 0.0 0.0)

hash1 : Double -> Double
hash1 value =
  fractF (sinF (value * 127.1 + 31.7) * 43758.5453123)

remote_pole_direction : Double -> SVec 2
remote_pole_direction index =
  let angle = tau * hash1 (index + 0.11)
   in vec2 (cosF angle) (sinF angle)

remote_pole_radius_scale : Double -> Double
remote_pole_radius_scale index =
  mixF 2.75 4.0 (hash1 (index + 1.73))

remote_pole_orbit_speed : Double -> Double
remote_pole_orbit_speed index =
  mixF 0.11 0.19 (hash1 (index + 4.37))

remote_pole_handedness : Double -> Double
remote_pole_handedness index =
  if hash1 (index + 7.91) < 0.5 then -1.0 else 1.0

remote_pole_position : Double -> Double -> Double -> SVec 2
remote_pole_position index view_outer_radius time =
  let initial_direction = remote_pole_direction index
      initial_angle = atan2F (y initial_direction) (x initial_direction)
      angle =
        initial_angle
        + remote_pole_handedness index * remote_pole_orbit_speed index * time
      bend_phase = tau * hash1 (index + 11.23)
      radial_bend = 0.22 * sinF (2.0 * angle + bend_phase)
      radius = remote_pole_radius_scale index + radial_bend
      ellipticity = mixF (-0.08) 0.08 (hash1 (index + 14.67))
      orbit =
        vec2
          ((1.0 + ellipticity) * cosF angle)
          ((1.0 - ellipticity) * sinF angle)
   in scale (view_outer_radius * radius) orbit

covering
remote_measure_from :
  SVec 2 -> Double -> Double -> Double -> Double -> SVec 2 -> SVec 2
remote_measure_from point view_outer_radius time active index state =
  if index < minF active 24.0
     then
       let pole = remote_pole_position index view_outer_radius time
           next = vadd state (factor_measure point pole)
        in remote_measure_from
             point view_outer_radius time active (index + 1.0) next
     else state

covering
remote_measure : SVec 2 -> Double -> Double -> SVec 2
remote_measure point view_outer_radius time =
  remote_measure_from
    point view_outer_radius time 24.0 0.0 (vec2 0.0 0.0)

covering
holomorphic_q_from :
  SVec 2 -> SArray 5 (SVec 2) -> Double -> Double -> SVec 4 -> SVec 4
holomorphic_q_from u coefficients active index state =
  if index < minF active 5.0
     then
       let q = vec2 (x state) (y state)
           power = vec2 (z state) (w state)
           coefficient = array_at coefficients index
           next_q = vadd q (complex_multiply coefficient power)
           next_power = complex_multiply power u
           next =
             vec4
               (x next_q) (y next_q)
               (x next_power) (y next_power)
        in holomorphic_q_from u coefficients active (index + 1.0) next
     else state

covering
holomorphic_q : SVec 2 -> SArray 5 (SVec 2) -> SVec 2
holomorphic_q point coefficients =
  let u = scale (1.0 / 3.0) point
      state =
        holomorphic_q_from
          u coefficients 5.0 0.0
          (vec4 0.0 0.0 (x u) (y u))
   in vec2 (x state) (y state)

%export "glsles:fragment|v_ndc=in,u_resolution=uniform,u_zero_count=uniform,u_pole_count=uniform,u_zero_positions=uniform,u_pole_positions=uniform,u_holomorphic_coefficients=uniform,u_remote_pole_time=uniform,u_zoom=uniform"
covering
holomorphic_explorer_background :
  SVec 2 -> SVec 2 ->
  Int -> Int ->
  SArray 32 (SVec 2) -> SArray 32 (SVec 2) ->
  SArray 5 (SVec 2) ->
  Double -> Double ->
  SVec 4
holomorphic_explorer_background
  ndc resolution
  zero_count pole_count
  zero_positions pole_positions
  holomorphic_coefficients
  remote_pole_time zoom =
  let pixel_radius =
        0.42 * minF (x resolution) (y resolution) * zoom
      safe_pixel_radius = maxF pixel_radius 0.000001
      pixel =
        vec2
          (x ndc * 0.5 * x resolution)
          (y ndc * 0.5 * y resolution)
      point = scale (1.0 / safe_pixel_radius) pixel
      view_outer_radius =
        length (scale 0.5 resolution) / safe_pixel_radius

      zeros =
        factor_sum_32 point (int_to_double zero_count) zero_positions
      poles =
        factor_sum_32 point (int_to_double pole_count) pole_positions
      outside_poles =
        remote_measure point view_outer_radius remote_pole_time
      rational =
        vsub (vsub zeros poles) outside_poles

      q = holomorphic_q point holomorphic_coefficients
      phase = x rational + y q
      log_modulus = y rational + x q
      color = wegert_color phase log_modulus
   in vec4 (x color) (y color) (z color) 1.0

main : IO ()
main = pure ()
