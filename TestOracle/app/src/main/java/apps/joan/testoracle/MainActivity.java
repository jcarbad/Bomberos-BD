package apps.joan.testoracle;

import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Struct;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import oracle.sql.ARRAY;
import oracle.sql.Datum;

public class MainActivity extends AppCompatActivity {

    Button btnGo;
    TextView txtTest, txtLat, txtLong, txtRadio;
    Connection sqlConn;
    List<Hidrante> hidraRPH = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        getSupportActionBar().setTitle("Conocer RPH");
        btnGo = (Button)findViewById(R.id.btnGo);
        txtLat = (TextView) findViewById(R.id.txtLatitud);
        txtLong = (TextView) findViewById(R.id.txtLongitud);
        txtRadio = (TextView) findViewById(R.id.txtRadio);

        btnGo.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v){
                ConexionBD oracle = new ConexionBD();
                double lat = Double.parseDouble(txtLat.getText().toString()),
                        longi = Double.parseDouble(txtLong.getText().toString());
                int rad = Integer.parseInt(txtRadio.getText().toString());
                oracle.execute(new BigDecimal(lat), new BigDecimal(longi), new BigDecimal(rad));
            }
        });
    }

    private class ConexionBD  extends AsyncTask<BigDecimal,Integer,List<Hidrante>> {
        BigDecimal latitud, longitud, radio;

        @Override
        protected List<Hidrante> doInBackground(BigDecimal... params) {
            Connection sqlConn;
            List<Hidrante> enRango = new ArrayList<>();
            latitud = params[0];
            longitud = params[1];
            radio = params[2];
            String URL = "jdbc:oracle:thin:@//bomberosbd.cdx79lvts9t5.us-east-2.rds.amazonaws.com:1521/ORCL";
            try {
                Class.forName("oracle.jdbc.driver.OracleDriver").newInstance();
                sqlConn = DriverManager.getConnection(URL, "bombero", "bombero");
                PreparedStatement st = sqlConn.prepareStatement("SELECT RPH(GeoPoint(" + latitud + ", " + longitud + "), " + radio + ") FROM DUAL");
                ResultSet rs = st.executeQuery();
                //IP = String.valueOf(rs.getMetaData().getColumnTypeName(1));
                if(rs.next()){
                    ARRAY arrayHidrantes = (ARRAY) rs.getArray(1);
                    Datum[] datumArray = arrayHidrantes.getOracleArray();
                    for (Datum dato : datumArray) {
                        Struct hidrante = (Struct) dato;
                        Object[] str = hidrante.getAttributes();
                        Struct GeoPoint = (Struct) hidrante.getAttributes()[0];
                        BigDecimal  lat = (BigDecimal) GeoPoint.getAttributes()[0],
                                    longi = (BigDecimal) GeoPoint.getAttributes()[1];
                        BigDecimal  calle = (BigDecimal) hidrante.getAttributes()[1],
                                    avenida = (BigDecimal) hidrante.getAttributes()[2],
                                    caudal = (BigDecimal) hidrante.getAttributes()[3];
                        Datum[] salidas = ((ARRAY) hidrante.getAttributes()[4]).getOracleArray();
                        int sal1 = salidas[0].intValue(),
                            sal2 = salidas[1].intValue(),
                            sal3 = salidas[2].intValue(),
                            sal4 = salidas[3].intValue();
                        BigDecimal  estado = (BigDecimal) hidrante.getAttributes()[5];
                        Timestamp ultima_rev = (Timestamp)hidrante.getAttributes()[7];
                        String ult_rev = new SimpleDateFormat("dd/MM/yyyy").format(ultima_rev);
                        BigDecimal pendiente = (BigDecimal) hidrante.getAttributes()[8];
                        enRango.add(new Hidrante(lat, longi, calle, avenida, caudal, new int[]{sal1, sal2, sal3, sal4}, estado, ult_rev, pendiente, new BigDecimal(0.0)));
                    }
                }

                st.close();
                sqlConn.close();
            } catch (Exception e) {
                System.out.println(e.toString());
                return null;
            }

            return enRango;
        }

        @Override
        protected void onPostExecute(List<Hidrante> resultante) {
            //super.onPostExecute(aVoid);
            hidraRPH = resultante;
            Intent intento = new Intent(getApplicationContext(), MapsActivity.class);
            Bundle b = new Bundle();
            b.putParcelableArrayList("hidrantes", (ArrayList<Hidrante>) hidraRPH);
            intento.putExtras(b);
            intento.putExtra("coords", new double[]{latitud.doubleValue(), longitud.doubleValue()});
            intento.putExtra("radio", radio.intValue());
            startActivity(intento);
        }

        public void Mensaje(String msg){
            Toast.makeText(getApplicationContext(), msg, Toast.LENGTH_SHORT).show();};
    }
}
