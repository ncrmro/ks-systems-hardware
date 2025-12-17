import anchorscad as ad

box = ad.Box([10, 10, 10])
try:
    print("Trying face_corner(0, 0)")
    box.at("face_corner", 0, 0)
    print("Success")
except Exception as e:
    print(f"Failed: {e}")

try:
    print("Trying face_corner(0)")
    box.at("face_corner", 0)
    print("Success")
except Exception as e:
    print(f"Failed: {e}")
