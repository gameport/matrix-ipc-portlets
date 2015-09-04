package ram.gameport.portlet.display.controller;

import com.google.gson.Gson;
import com.liferay.portal.kernel.json.JSONArray;
import com.liferay.portal.kernel.json.JSONSerializer;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.ReleaseInfo;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import org.codehaus.jackson.map.ObjectMapper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.portlet.bind.annotation.RenderMapping;
import org.springframework.web.portlet.bind.annotation.ResourceMapping;
import ram.gameport.service.matrix.model.Matrix;
import ram.gameport.service.matrix.service.MatrixLocalServiceUtil;

import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;
import java.io.PrintWriter;
import java.util.List;

/**
 * Created by gamport.
 */

@Controller
@RequestMapping("VIEW")
public class DisplayPortletController {

	private Log _log = LogFactoryUtil.getLog(DisplayPortletController.class);

	@RenderMapping
	public String question(Model model) {
		return "matrix-display-portlet/view";
	}

	@ResourceMapping(value = "displayMatrix")
	public void serveMatrix(ResourceRequest resourceRequest, ResourceResponse resourceResponse) {

		ObjectMapper mapper = new ObjectMapper();

		String command = ParamUtil.getString(resourceRequest, "COMMAND");

		if ("GetMatrix".equalsIgnoreCase(command)) {
			int matrixCount;

			List<Matrix> mList = null;
			try {
				matrixCount = MatrixLocalServiceUtil.getMatrixsCount();
				mList = MatrixLocalServiceUtil.getMatrixs(0, matrixCount);

				String json = new Gson().toJson(mList);

				final PrintWriter writer = resourceResponse.getWriter();
				final String jsonString = mapper.writeValueAsString(json);

				writer.write(jsonString);
				writer.flush();
				writer.close();
			} catch (Exception e) {
				_log.warn("Unable to parse the Json response map");
				e.printStackTrace();
			}
		}
	}
}
