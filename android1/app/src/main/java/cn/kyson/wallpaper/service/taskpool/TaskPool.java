package cn.kyson.wallpaper.service.taskpool;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

import android.annotation.SuppressLint;
import android.os.Message;
import android.util.Log;

import cn.kyson.wallpaper.service.networkaccess.Field_Method_Parameter_Annotation;
import cn.kyson.wallpaper.service.networkaccess.ServiceMediator;
import cn.kyson.wallpaper.service.networkaccess.ServiceResponse;

@SuppressWarnings("rawtypes")
@SuppressLint({ "DefaultLocale", "rawtypes" })
public class TaskPool {
	private static TaskPool instance = new TaskPool();
	private ServiceMediator serviceMediator;
	private static final int corePoolSize = 2;
	private static final int maximumPoolSize = 20;
	private static BlockingQueue<Runnable> workQueue = new ArrayBlockingQueue<Runnable>(maximumPoolSize);
	private static ThreadFactory factory = new ThreadFactory() {
		@Override
		public Thread newThread(Runnable r) {
			Thread t = new Thread(r);
			return t;
		}
	};

	private static ThreadPoolExecutor executor = new ThreadPoolExecutor(corePoolSize, maximumPoolSize, 60, TimeUnit.SECONDS, workQueue, factory);

	public static synchronized TaskPool sharedInstance() {
		synchronized (TaskPool.class) {
			if (instance == null) {
				instance = new TaskPool();
			}
			return instance;
		}
	}

	public void setServiceMediator(ServiceMediator mediator) {
		serviceMediator = mediator;
	}

	public <T> String doTask(final ViewModel viewModel, final String method) {
		final String token = getTaskToken(method);
		if (tokenManager.values().contains(method)) {
			return null;
		}
		tokenManager.put(token, method);

		Runnable runnable = new Runnable() {
			private ViewModel vModel = ViewModelManager.manager().viewModelForKey(viewModel.getActivityToken());
			private String strActivityClasString = viewModel.getActivityClass();
			private String strActivityToken = viewModel.getActivityToken();
			private String strTargetMethod = method;
			private String strToken = token;

			@SuppressWarnings("unchecked")
			public void run() {
				Method method = serviceMediator.getMethodByName(strTargetMethod);
				Object[] objects = null;
				if (method.isAnnotationPresent(Field_Method_Parameter_Annotation.class)) {
					Field_Method_Parameter_Annotation annotation = method.getAnnotation(Field_Method_Parameter_Annotation.class);
					if (annotation.args() != null) {
						objects = new Object[annotation.args().length];
						for (int i = 0; i < annotation.args().length; i++) {
							String strValue = annotation.args()[i];
							try {
								Field fd = vModel.getClass().getField(strValue);
								Object valueObject = fd.get(vModel);
								objects[i] = valueObject;
							} catch (NoSuchFieldException e) {
								e.printStackTrace();
							} catch (IllegalAccessException e) {
								e.printStackTrace();
							}
						}
					} else {
						objects = new Object[0];
					}
				} else {
					objects = new Object[0];
				}

				ServiceResponse<T> response = null;
				try {
					response = (ServiceResponse<T>) method.invoke(serviceMediator, objects);
					response.setRequestMethod(strTargetMethod);
					response.setActivityClass(strActivityClasString);
					response.setActivityToken(strActivityToken);
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
					removeTask(strToken);
				} catch (IllegalAccessException e) {
					e.printStackTrace();
					removeTask(strToken);
				} catch (InvocationTargetException e) {
					e.printStackTrace();
					removeTask(strToken);
				}

				Message message = new Message();
				if (isContains(strToken)) {
					removeTask(strToken);
					message.what = response.getReturnCode();
					message.obj = response;
					ViewModelManager.manager().getHandler().sendMessage(message);
				} else {
					Log.i("xuehantest", "canceled == " + strToken);
				}
			}
		};

		executor.execute(runnable);
		return token;
	}

	public Boolean isContains(String token) {
		Boolean isContains = true;
		if (null == tokenManager.get(token)) {
			isContains = false;
		}
		return isContains;
	}

	public void removeTask(String token) {
		tokenManager.remove(token);
	}

	private HashMap<String, String> tokenManager = new HashMap<String, String>();

	private static long counter = 0;

	private String getTaskToken(String method) {
		String token = method + "@" + counter;
		counter += 1;
		return token;
	}

	private static long activityCounter = 0;

	public long getActivityCounter() {
		activityCounter += 1;
		return activityCounter;
	}

}
