import anchorscad as ad
from anchorscad import datatree
from dataclasses import field
from registry import register_part
from config import PicoDimensions
from lib.storage import SSD25Dimensions

@ad.shape
@datatree
class SsdHarness(ad.CompositeShape):
    """
    SSD harness for 2x 2.5" SSDs.
    Ported from modules/case/panels/standard/top_pico.scad
    """
    dim: PicoDimensions
    ssd_dim: SSD25Dimensions = field(default_factory=SSD25Dimensions)
    
    def build(self) -> ad.Maker:
        wall = self.dim.wall_thickness
        divider_h = 10.0 # Increased from 9.0 to better clear 9.5mm SSDs
        bridge = 3.0
        # SSD25Dimensions from lib/storage.py uses width, length, height
        # width: 69.85, length: 100.0, height: 9.5
        
        channel_w = 3.3 + 0.5 # M3 + clearance
        channel_depth = wall + 0.2
        
        w_panel = self.dim.pico_case_width
        d_panel = self.dim.pico_case_depth
        
        # SSD1: Back-left zone
        ssd1_front_y_abs = d_panel - self.ssd_dim.width - 2 * wall
        ssd1_front_y_rel = ssd1_front_y_abs - d_panel/2
        
        # Horizontal lip along front edge of SSD 1
        lip1 = ad.Box([self.ssd_dim.length, wall, divider_h])
        lip1_x_rel = (wall + self.ssd_dim.length/2) - w_panel/2
        
        shape = lip1.solid("lip1").colour("gray").at("centre", post=ad.translate([lip1_x_rel, ssd1_front_y_rel, -divider_h/2]))
        
        # Screw channels for lip1
        channel_pos_x_abs = [
            wall + 14.0, # hole_front_y in storage.py
            wall + 90.6  # hole_rear_y in storage.py
        ]
        
        for i, x_abs in enumerate(channel_pos_x_abs):
            x_rel = x_abs - w_panel/2
            channel = ad.Box([channel_w, channel_depth, divider_h - bridge + 0.1])
            shape.add_at(
                channel.hole(f"channel1_{i}").at("centre"),
                post=ad.translate([x_rel, ssd1_front_y_rel, -divider_h + bridge + (divider_h - bridge)/2])
            )
            
        # Vertical divider (separates back-left and front-right SSD zones)
        divider_x_abs = self.ssd_dim.length + wall
        divider_x_rel = divider_x_abs - w_panel/2
        divider_len = ssd1_front_y_abs + 20 # overlaps slightly
        
        divider_y_rel = divider_len/2 - d_panel/2
        
        divider2 = ad.Box([wall, divider_len, divider_h])
        shape.add_at(
            divider2.solid("divider2").colour("gray").at("centre"),
            post=ad.translate([divider_x_rel, divider_y_rel, -divider_h/2])
        )
        
        # Screw channels for divider2
        channel_pos_y_abs = [14.0, 90.6]
        for i, y_abs in enumerate(channel_pos_y_abs):
            y_rel = y_abs - d_panel/2
            channel = ad.Box([channel_depth, channel_w, divider_h - bridge + 0.1])
            shape.add_at(
                channel.hole(f"channel2_{i}").at("centre"),
                post=ad.translate([divider_x_rel, y_rel, -divider_h + bridge + (divider_h - bridge)/2])
            )

        # SSD2: Front-right zone
        # Horizontal lip along back edge of SSD 2
        ssd2_back_y_abs = self.ssd_dim.length + wall
        ssd2_back_y_rel = ssd2_back_y_abs - d_panel/2
        
        lip3_w = w_panel - divider_x_abs - wall
        lip3_x_abs = divider_x_abs + wall + lip3_w/2
        lip3_x_rel = lip3_x_abs - w_panel/2
        
        lip3 = ad.Box([lip3_w, wall, divider_h])
        shape.add_at(
            lip3.solid("lip3").colour("gray").at("centre"),
            post=ad.translate([lip3_x_rel, ssd2_back_y_rel, -divider_h/2])
        )

        # Screw channels for lip3 (X-axis of SSD2)
        # SSD2 is oriented differently? Assuming same orientation.
        # Wait, if width 69.85 fits in 73mm, it's oriented with length along Y?
        # SSD1: length (100) along X. width (69.85) along Y.
        # SSD2: length (100) along Y. width (69.85) along X?
        # If X range is 103 to 176, width is 73. Fits 69.85.
        # If Y range is 0 to 103, length is 103. Fits 100.
        # Yes, SSD2 is rotated 90 deg relative to SSD1.
        
        # Screw holes for SSD2 (length along Y)
        for i, y_abs in enumerate(channel_pos_y_abs):
            y_rel = y_abs - d_panel/2
            # lip3 is at Y=103. SSD2 holes are at Y=14 and Y=90.6.
            # lip3 won't have screw channels for SSD2 if they are side-mounted.
            # But SSD harness usually uses side holes.
            pass
            
        return shape

@register_part("parts_ssd_harness")
def create_ssd_harness() -> ad.Shape:
    return SsdHarness(dim=PicoDimensions())
