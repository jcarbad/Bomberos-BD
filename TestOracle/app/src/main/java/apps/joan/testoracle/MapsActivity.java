package apps.joan.testoracle;

import android.os.Bundle;
import android.support.v4.app.FragmentActivity;

import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.OnMapReadyCallback;
import com.google.android.gms.maps.SupportMapFragment;
import com.google.android.gms.maps.model.Circle;
import com.google.android.gms.maps.model.CircleOptions;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;

import java.util.ArrayList;

public class MapsActivity extends FragmentActivity implements OnMapReadyCallback {

    private GoogleMap mMap;
    ArrayList<Hidrante> hidrantes;
    double[] Coords;
    int radio;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_maps);
        // Obtain the SupportMapFragment and get notified when the map is ready to be used.
        SupportMapFragment mapFragment = (SupportMapFragment) getSupportFragmentManager()
                .findFragmentById(R.id.map);
        mapFragment.getMapAsync(this);
        hidrantes = getIntent().getParcelableArrayListExtra("hidrantes");
        Coords = getIntent().getDoubleArrayExtra("coords");
        radio = getIntent().getIntExtra("radio", 0);
    }

    @Override
    public void onMapReady(GoogleMap googleMap) {
        mMap = googleMap;
        for (Hidrante hidra : hidrantes){
            mMap.addMarker(new MarkerOptions().position(new LatLng(hidra.getLatitud().doubleValue(), hidra.getLongitud().doubleValue())).title("Calle " + hidra.getCalle().intValue() + " y Avenida" + hidra.getAvenida().intValue()));
        }
        TrazarRPH();
    }

    private void TrazarRPH() {
        // Instantiates a new CircleOptions object and defines the center and radius
        CircleOptions circleOptions = new CircleOptions()
                .center(new LatLng(Coords[0], Coords[1]))
                .radius(radio); // In meters

        // Get back the mutable Circle
        Circle circle = mMap.addCircle(circleOptions);
    }
}
