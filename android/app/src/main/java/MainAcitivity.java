package com.example.mygooglemaps;


public class MainActivity extends AppCompatActivity implements OnMapReadyCallback {

    private GoogleMap myMap;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Get the SupportMapFragment and request notification when the map is ready
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        myMap = googleMap;

        // Add a marker in Sydney, Australia, and move the camera
        LatLng bangladesh = new LatLng(23.6850, 90.3563);
        myMap.addMarker(new MarkerOptions().position(bangladesh).title("Bangladesh"));
        myMap.moveCamera(CameraUpdateFactory.newLatLngZoom(bangladesh, 12));
    }

