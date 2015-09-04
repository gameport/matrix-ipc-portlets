package ram.gameport.portlet.details.controller;

import com.google.gson.Gson;
import com.liferay.portal.kernel.json.JSONFactoryUtil;
import com.liferay.portal.kernel.json.JSONSerializer;
import com.liferay.portal.kernel.log.Log;
import com.liferay.portal.kernel.log.LogFactoryUtil;
import com.liferay.portal.kernel.util.ParamUtil;
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

/**
 * Created by gamport.
 */

@Controller
@RequestMapping("VIEW")
public class DetailsPortletController {

	private Log _log = LogFactoryUtil.getLog(DetailsPortletController.class);

	@RenderMapping
	public String question(Model model) {
		return "matrix-details-portlet/view";
	}

	@ResourceMapping(value = "matrixDetails")
	public void getMatrixDetails(ResourceRequest resourceRequest,
	                             ResourceResponse resourceResponse) {

		ObjectMapper mapper = new ObjectMapper();
		String matrixName = ParamUtil.getString(resourceRequest, "name");

		try {
			Matrix matrix = null;
			matrix = MatrixLocalServiceUtil.findByMatrixName(matrixName);
			String json = new Gson().toJson(matrix);

			final PrintWriter writer = resourceResponse.getWriter();
			final String jsonString = mapper.writeValueAsString(json);

			writer.write(jsonString);
			writer.flush();
			writer.close();
		} catch (final Exception e) {
			_log.warn("Unable to parse the Json response");
		}
	}
}



